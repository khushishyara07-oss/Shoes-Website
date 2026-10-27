using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Shoes_Project
{
    public partial class Login : System.Web.UI.Page
    {
        SqlConnection con;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["user"] != null)
            {
                if (Convert.ToString(Session["role"]) == "Admin")
                {
                    Response.Redirect("Company.aspx");
                }
                else
                {
                    Response.Redirect("Default.aspx");
                }
            }
        }

        protected void btnlogin_Click(object sender, EventArgs e)
        {
            string email = txtusername.Text.Trim().Replace("'", "''");
            string pass = txtpassword.Text.Trim().Replace("'", "''");

            if (email == "" || pass == "")
            {
                Response.Write("<script>alert('Please enter email and password')</script>");
                return;
            }

            con = new SqlConnection(s);
            da = new SqlDataAdapter("select * from emp_tbl where Email='" + email + "' and Password='" + pass + "'", con);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables[0].Rows.Count > 0)
            {
                // uid is used by cart and orders (same as login.aspx.cs of Database_Connectivity)
                Session["uid"] = ds.Tables[0].Rows[0]["Id"].ToString();
                Session["user"] = ds.Tables[0].Rows[0]["Name"].ToString();
                Session["email"] = ds.Tables[0].Rows[0]["Email"].ToString();

                // role: Admin or User (User if the column is empty)
                string role = "User";

                if (ds.Tables[0].Columns.Contains("Role") && ds.Tables[0].Rows[0]["Role"].ToString().Trim().ToLower() == "admin")
                {
                    role = "Admin";
                }

                Session["role"] = role;

                if (role == "Admin")
                {
                    Response.Redirect("Company.aspx");
                }
                else
                {
                    Response.Redirect("Default.aspx");
                }
            }
            else
            {
                Response.Write("<script>alert('Invalid Email or Password')</script>");
            }
        }
    }
}