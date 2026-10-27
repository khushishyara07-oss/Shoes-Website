using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Shoes_Project
{
    // logic of Add_To_Cart.aspx.cs (Database_Connectivity project)
    public partial class Cart : System.Web.UI.Page
    {
        SqlConnection con;
        SqlDataAdapter da;
        DataSet ds;
        SqlCommand cmd;

        int uid;

        string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

        void getCon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        void fillGrid()
        {
            getCon();

            uid = Convert.ToInt32(Session["uid"]);

            da = new SqlDataAdapter(
                "SELECT " +
                "Cart_Tbl.Cart_Id, " +
                "Add_Products_Tbl.Prod_Id, " +
                "Add_Products_Tbl.Prod_Img, " +
                "Add_Products_Tbl.Prod_Name, " +
                "Add_Products_Tbl.Prod_Model, " +
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

            // Calculate line totals and Sub Total
            ds.Tables[0].Columns.Add("LineTotal", typeof(decimal));

            decimal total = 0;

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                decimal price = Convert.ToDecimal(row["Prod_Price"]);
                int quantity = Convert.ToInt32(row["Quentity"]);

                row["LineTotal"] = price * quantity;

                total = total + (price * quantity);
            }

            bool hasItems = ds.Tables[0].Rows.Count > 0;

            pnlCart.Visible = hasItems;
            pnlEmpty.Visible = !hasItems;

            GridView1.DataSource = ds;
            GridView1.DataBind();

            decimal delivery = 0;

            // free delivery above ₹1000, otherwise ₹50
            if (total > 0 && total <= 1000)
            {
                delivery = 50;
            }


            lblSubtotal.Text = "₹" + total.ToString("N2");
            lblDelivery.Text = delivery == 0 ? "Free" : "₹" + delivery.ToString("N2");
            grand_total.Text = "₹" + (total + delivery).ToString("N2");
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

            if (!IsPostBack)
            {
                uid = Convert.ToInt32(Session["uid"]);

                lblWelcome.Text = "Welcome, " + Session["user"].ToString();

                fillGrid();
            }
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "cmd_remove")
            {
                int cartId = Convert.ToInt32(e.CommandArgument);

                getCon();

                cmd = new SqlCommand("DELETE FROM Cart_Tbl WHERE Cart_Id = " + cartId, con);

                cmd.ExecuteNonQuery();

                con.Close();

                fillGrid();
            }
        }

        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;

            fillGrid();

            // show the current quantity selected in the dropdown
            DropDownList ddl = (DropDownList)GridView1.Rows[e.NewEditIndex].FindControl("DropDownList1");
            string q = ds.Tables[0].Rows[e.NewEditIndex]["Quentity"].ToString();

            if (ddl.Items.FindByValue(q) == null)
            {
                ddl.Items.Add(new ListItem(q, q));
            }

            ddl.SelectedValue = q;
        }

        protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;

            fillGrid();
        }

        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int productId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

            DropDownList ddl = (DropDownList)GridView1.Rows[e.RowIndex].FindControl("DropDownList1");

            int quantity = Convert.ToInt32(ddl.SelectedValue);

            uid = Convert.ToInt32(Session["uid"]);

            getCon();

            cmd = new SqlCommand(
                "UPDATE Cart_Tbl SET Quentity = " + quantity +
                " WHERE Cart_User_Id = " + uid +
                " AND Cart_Prod_Id = " + productId,
                con
            );

            cmd.ExecuteNonQuery();

            con.Close();

            GridView1.EditIndex = -1;

            fillGrid();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("Checkout.aspx");
        }
    }
}