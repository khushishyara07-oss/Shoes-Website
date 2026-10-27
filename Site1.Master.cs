using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Shoes_Project
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["logout"] == "1")
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("Login.aspx");
            }
        }

        // number shown on the cart icon, comes from Cart_Tbl
        protected int CartCount()
        {
            if (Session["uid"] == null)
            {
                return 0;
            }

            try
            {
                int userId = Convert.ToInt32(Session["uid"]);

                SqlConnection con = new SqlConnection(s);
                con.Open();

                SqlCommand cmd = new SqlCommand(
                    "SELECT ISNULL(SUM(Quentity), 0) FROM Cart_Tbl WHERE Cart_User_Id = " + userId, con);

                int total = Convert.ToInt32(cmd.ExecuteScalar());

                con.Close();

                return total;
            }
            catch
            {
                return 0;
            }
        }
    }
}
