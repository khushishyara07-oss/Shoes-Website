using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI.WebControls;

namespace Shoes_Project
{
    // Customer details come from emp_tbl (logged in user), items come from Cart_Tbl
    public partial class Checkout : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        int uid;

        string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

        void getCon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        void Msg(string text, bool ok)
        {
            string color = ok ? "#166534" : "#b91c1c";
            string bg = ok ? "#dcfce7" : "#fee2e2";
            lblMsg.Text = "<div style='padding:10px 14px;margin-bottom:16px;border-radius:6px;color:" + color +
                          ";background:" + bg + ";'>" + HttpUtility.HtmlEncode(text) + "</div>";
        }

        // cart rows of the logged in user (same join as Add_To_Cart.aspx.cs)
        DataTable getCartRows()
        {
            getCon();

            da = new SqlDataAdapter(
                "SELECT " +
                "Cart_Tbl.Cart_Id, " +
                "Add_Products_Tbl.Prod_Id, " +
                "Add_Products_Tbl.Prod_Img, " +
                "Add_Products_Tbl.Prod_Name, " +
                "Add_Products_Tbl.Prod_Price, " +
                "Cart_Tbl.Quentity " +
                "FROM Cart_Tbl " +
                "INNER JOIN Add_Products_Tbl " +
                "ON Cart_Tbl.Cart_Prod_Id = Add_Products_Tbl.Prod_Id " +
                "WHERE Cart_Tbl.Cart_User_Id = " + uid + " ORDER BY Cart_Tbl.Cart_Id",
                con
            );

            ds = new DataSet();

            da.Fill(ds);

            con.Close();

            ds.Tables[0].Columns.Add("LineTotal", typeof(decimal));

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                decimal price = Convert.ToDecimal(row["Prod_Price"]);
                int quantity = Convert.ToInt32(row["Quentity"]);

                row["LineTotal"] = price * quantity;
            }

            return ds.Tables[0];
        }

        decimal getSubTotal(DataTable dt)
        {
            decimal total = 0;

            foreach (DataRow row in dt.Rows)
            {
                total = total + Convert.ToDecimal(row["LineTotal"]);
            }

            return total;
        }

        void fillSummary()
        {
            DataTable dt = getCartRows();

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("Cart.aspx");
                return;
            }

            rptItems.DataSource = dt;
            rptItems.DataBind();

            decimal subtotal = getSubTotal(dt);
            decimal delivery = 0;

            // free delivery above ₹1000, otherwise ₹50
            if (subtotal > 0 && subtotal <= 1000)
            {
                delivery = 50;
            }


            lblSubtotal.Text = "₹" + subtotal.ToString("N2");
            lblDelivery.Text = delivery == 0 ? "Free" : "₹" + delivery.ToString("N2");
            lblGrand.Text = "₹" + (subtotal + delivery).ToString("N2");
        }

        // fill customer details from emp_tbl
        void fillCustomer()
        {
            getCon();

            da = new SqlDataAdapter("select * from emp_tbl where Id = " + uid, con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow row = ds.Tables[0].Rows[0];

                txtName.Text = row["Name"].ToString();
                txtEmail.Text = row["Email"].ToString();
                txtMobile.Text = row["Mobile"].ToString();
                txtAddress.Text = row["Address"].ToString() + ", " + row["City"].ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uid"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // cart and orders are only for users, admin goes home
            if (Convert.ToString(Session["role"]) == "Admin")
            {
                Response.Redirect("Default.aspx");
                return;
            }

            uid = Convert.ToInt32(Session["uid"]);

            if (!IsPostBack)
            {
                fillCustomer();
                fillSummary();
            }
        }

        protected void btn_place_Click(object sender, EventArgs e)
        {
            string name = txtName.Text.Trim().Replace("'", "''");
            string email = txtEmail.Text.Trim().Replace("'", "''");
            string mobile = txtMobile.Text.Trim().Replace("'", "''");
            string address = txtAddress.Text.Trim().Replace("'", "''");
            string payMode = ddlPayment.SelectedValue.Replace("'", "''");

            if (name == "" || email == "" || mobile == "" || address == "")
            {
                Msg("Please fill name, email, mobile and address.", false);
                fillSummary();
                return;
            }

            // read the cart again from the database
            DataTable dt = getCartRows();

            if (dt.Rows.Count == 0)
            {
                Response.Redirect("Cart.aspx");
                return;
            }

            decimal subtotal = getSubTotal(dt);
            decimal delivery = 0;

            // free delivery above ₹1000, otherwise ₹50
            if (subtotal > 0 && subtotal <= 1000)
            {
                delivery = 50;
            }

            decimal grand = subtotal + delivery;

            // COD is paid on delivery, other methods are treated as paid (demo, no payment gateway)
            string payStatus = (payMode == "Cash on Delivery") ? "Pending" : "Paid";

            getCon();

            SqlTransaction tran = con.BeginTransaction();

            try
            {
                // 1. new order number (all rows of this order share it)
                cmd = new SqlCommand(
                    "SELECT ISNULL(MAX(Order_No), 0) + 1 FROM Order_Tbl WITH (UPDLOCK, HOLDLOCK)",
                    con, tran
                );

                int orderId = Convert.ToInt32(cmd.ExecuteScalar());

                // 2. insert every cart item as one row in Order_Tbl
                foreach (DataRow row in dt.Rows)
                {
                    string pname = row["Prod_Name"].ToString().Replace("'", "''");
                    string pimg = row["Prod_Img"].ToString().Replace("'", "''");

                    cmd = new SqlCommand(
                        "INSERT INTO Order_Tbl " +
                        "(Order_No, Order_User_Id, Order_Date, Cust_Name, Cust_Email, Cust_Mobile, Cust_Address, " +
                        "Item_Prod_Id, Item_Name, Item_Img, Item_Price, Item_Qty, " +
                        "Sub_Total, Delivery_Charge, Grand_Total, Pay_Method, Pay_Status) " +
                        "VALUES (" + orderId + ", " + uid + ", GETDATE(), '" + name + "', '" + email + "', '" + mobile + "', '" + address + "', " +
                        row["Prod_Id"] + ", '" + pname + "', '" + pimg + "', " +
                        Convert.ToDecimal(row["Prod_Price"]).ToString(CultureInfo.InvariantCulture) + ", " +
                        row["Quentity"] + ", " +
                        subtotal.ToString(CultureInfo.InvariantCulture) + ", " +
                        delivery.ToString(CultureInfo.InvariantCulture) + ", " +
                        grand.ToString(CultureInfo.InvariantCulture) + ", " +
                        "'" + payMode + "', '" + payStatus + "')",
                        con, tran
                    );

                    cmd.ExecuteNonQuery();
                }

                // 3. empty the cart
                cmd = new SqlCommand("DELETE FROM Cart_Tbl WHERE Cart_User_Id = " + uid, con, tran);
                cmd.ExecuteNonQuery();

                tran.Commit();
                con.Close();

                Response.Redirect("OrderSuccess.aspx?oid=" + orderId, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (System.Threading.ThreadAbortException)
            {
                throw;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                con.Close();

                Msg("Order could not be placed: " + ex.Message, false);
                fillSummary();
            }
        }
    }
}