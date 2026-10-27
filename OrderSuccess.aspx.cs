using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;

namespace Shoes_Project
{
   
    public partial class OrderSuccess : System.Web.UI.Page
    {
        SqlConnection con;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

        void getCon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        void fillOrder(int orderId, int uid)
        {
            getCon();

          
            da = new SqlDataAdapter(
                "select * from Order_Tbl where Order_No = " + orderId + " and Order_User_Id = " + uid +
                " order by Order_Row_Id", con);

            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            if (ds.Tables[0].Rows.Count == 0)
            {
                Response.Redirect("Default.aspx");
                return;
            }


            DataRow row = ds.Tables[0].Rows[0];

            lblOrderNo.Text = "#" + row["Order_No"].ToString();
            lblOrderDate.Text = Convert.ToDateTime(row["Order_Date"]).ToString("dd MMM yyyy, hh:mm tt");
            lblCustName.Text = HttpUtility.HtmlEncode(row["Cust_Name"].ToString());
            lblEmail.Text = HttpUtility.HtmlEncode(row["Cust_Email"].ToString());
            lblMobile.Text = HttpUtility.HtmlEncode(row["Cust_Mobile"].ToString());
            lblAddress.Text = HttpUtility.HtmlEncode(row["Cust_Address"].ToString());

            decimal delivery = Convert.ToDecimal(row["Delivery_Charge"]);

            lblSubTotal.Text = "₹" + Convert.ToDecimal(row["Sub_Total"]).ToString("N2");
            lblDelivery.Text = delivery == 0 ? "Free" : "₹" + delivery.ToString("N2");
            lblGrandTotal.Text = "₹" + Convert.ToDecimal(row["Grand_Total"]).ToString("N2");
            lblPayMode.Text = HttpUtility.HtmlEncode(row["Pay_Method"].ToString());
            lblPayStatus.Text = HttpUtility.HtmlEncode(row["Pay_Status"].ToString());

            
            GridView1.DataSource = ds;
            GridView1.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["uid"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

           
            if (Convert.ToString(Session["role"]) == "Admin")
            {
                Response.Redirect("Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int orderId;

                if (!int.TryParse(Request.QueryString["oid"], out orderId))
                {
                    Response.Redirect("Default.aspx");
                    return;
                }

                fillOrder(orderId, Convert.ToInt32(Session["uid"]));
            }
        }
    }
}