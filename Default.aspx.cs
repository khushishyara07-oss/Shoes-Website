using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Shoes_Project
{
    public partial class Default : System.Web.UI.Page
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

        void fillFeatured()
        {
            getCon();

            da = new SqlDataAdapter("select top 4 * from Add_Products_Tbl order by Prod_Id desc", con);
            ds = new DataSet();
            da.Fill(ds);

            rptFeatured.DataSource = ds;
            rptFeatured.DataBind();

            pnlNoFeatured.Visible = (ds.Tables[0].Rows.Count == 0);

            con.Close();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillFeatured();
            }
        }

        protected void rptFeatured_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // View Details
            if (e.CommandName == "cmd_view")
            {
                int id = Convert.ToInt32(e.CommandArgument);

                Response.Redirect("ProductDetails.aspx?pid=" + id);
            }

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

                // Check whether product is already in cart
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
                    // Product already exists, increase quantity by 1
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
                    // Product does not exist, add new product to cart
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

                // After adding product, open cart
                Response.Redirect("Cart.aspx");
            }
        }
    }
}