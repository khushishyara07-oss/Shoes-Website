using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Shoes_Project
{
    public partial class Products : Page
    {
        SqlConnection con;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindData();
            }
        }

        void BindData()
        {
            con = new SqlConnection(s);
            ds = new DataSet();

            // only companies which have products
            da = new SqlDataAdapter(
                "select Comp_Id, Comp_Name, Comp_Owner_Name, Comp_Address, Comp_Cover_Img from Add_Company_Tbl " +
                "where Comp_Id in (select Prod_Comp_Id from Add_Products_Tbl) order by Comp_Name", con);
            da.Fill(ds, "companies");

            da = new SqlDataAdapter("select * from Add_Products_Tbl order by Prod_Name", con);
            da.Fill(ds, "products");

            // sidebar links
            rptCompanyLinks.DataSource = ds.Tables["companies"];
            rptCompanyLinks.DataBind();

            // company filter from link
            DataView dv = new DataView(ds.Tables["companies"]);

            int selected;
            if (int.TryParse(Request.QueryString["company"], out selected))
            {
                dv.RowFilter = "Comp_Id = " + selected;
            }

            rptCompanies.DataSource = dv;
            rptCompanies.DataBind();

            pnlEmpty.Visible = (dv.Count == 0);
        }

        // products inside each company
        protected void rptCompanies_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            {
                return;
            }

            DataRowView drv = (DataRowView)e.Item.DataItem;
            Repeater rptProducts = (Repeater)e.Item.FindControl("rptProducts");

            DataView pv = new DataView(ds.Tables["products"]);
            pv.RowFilter = "Prod_Comp_Id = " + drv["Comp_Id"];

            rptProducts.DataSource = pv;
            rptProducts.DataBind();
        }

        // View Details / Add To Cart  (same logic as Show_Products.aspx.cs of Database_Connectivity)
        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
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