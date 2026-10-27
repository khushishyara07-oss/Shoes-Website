using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Shoes_Project
{
    public partial class ProductDetails : System.Web.UI.Page
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

        void fillDetails()
        {
            int pid;

            if (!int.TryParse(Request.QueryString["pid"], out pid))
            {
                pnlNotFound.Visible = true;
                return;
            }

            getCon();

            da = new SqlDataAdapter(
                "SELECT p.*, c.Comp_Name FROM Add_Products_Tbl p " +
                "INNER JOIN Add_Company_Tbl c ON c.Comp_Id = p.Prod_Comp_Id " +
                "WHERE p.Prod_Id = " + pid, con);

            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables[0].Rows.Count > 0)
            {
                rptDetails.DataSource = ds;
                rptDetails.DataBind();
            }
            else
            {
                pnlNotFound.Visible = true;
            }

            con.Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillDetails();
            }
        }

        protected void rptDetails_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Add To Cart
            if (e.CommandName == "cmd_cart")
            {
                int productId = Convert.ToInt32(e.CommandArgument);

                // admin manages the shop, only users can buy
                if (Convert.ToString(Session["role"]) == "Admin")
                {
                    return;
                }

                if (Session["uid"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                int userId = Convert.ToInt32(Session["uid"]);

                SqlConnection con2 = new SqlConnection(s);
                con2.Open();

              
                SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Cart_Tbl WHERE Cart_User_Id = "
                    + userId +
                    " AND Cart_Prod_Id = "
                    + productId,
                    con2
                );

                int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (count > 0)
                {
                   
                    SqlCommand updateCmd = new SqlCommand(
                        "UPDATE Cart_Tbl SET Quentity = Quentity + 1 " +
                        "WHERE Cart_User_Id = " + userId +
                        " AND Cart_Prod_Id = " + productId,
                        con2
                    );

                    updateCmd.ExecuteNonQuery();
                }
                else
                {
                  
                    SqlCommand insertCmd = new SqlCommand(
                        "INSERT INTO Cart_Tbl " +
                        "(Cart_User_Id, Cart_Prod_Id, Quentity, AddedDate) " +
                        "VALUES (" +
                        userId + ", " +
                        productId + ", " +
                        "1, GETDATE())",
                        con2
                    );

                    insertCmd.ExecuteNonQuery();
                }

                con2.Close();

                Response.Redirect("Cart.aspx");
            }
        }
    }
}