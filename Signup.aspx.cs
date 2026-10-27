using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Shoes_Project
{
    public partial class Signup : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;
        string fnm;

        string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

        void getCon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        DataSet GetData(string query)
        {
            getCon();
            da = new SqlDataAdapter(query, con);
            ds = new DataSet();
            da.Fill(ds);
            con.Close();
            return ds;
        }

        void Execute(string query)
        {
            getCon();
            cmd = new SqlCommand(query, con);
            cmd.ExecuteNonQuery();
            con.Close();
        }

        void fileUpload()
        {
            if (imgupload.HasFile)
            {
                Directory.CreateDirectory(Server.MapPath("~/images"));
                string file = DateTime.Now.Ticks + "_" + Path.GetFileName(imgupload.FileName).Replace(" ", "_").Replace("'", "");
                imgupload.SaveAs(Server.MapPath("~/images/" + file));
                fnm = "images/" + file;
            }
            else
            {
                fnm = "";
            }
        }

        void fillGrid()
        {
            GridView1.DataSource = GetData("select * from emp_tbl");
            GridView1.DataBind();
        }

        void clear()
        {
            txtusername.Text = "";
            txtaddress.Text = "";
            txtemail.Text = "";
            txtmbl.Text = "";
            txtpassword.Text = "";
            rdogen.SelectedIndex = -1;
            drpcity.SelectedIndex = 0;
            ViewState["id"] = null;
            Save_btn.Text = "Save";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // users list (edit / delete) is only for admin
            bool isAdmin = Convert.ToString(Session["role"]) == "Admin";

            pnlUsers.Visible = isAdmin;

            if (!IsPostBack && isAdmin)
            {
                fillGrid();
            }
        }

        void fillData()
        {
            ds = GetData("select * from emp_tbl where Id='" + ViewState["id"] + "'");

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow row = ds.Tables[0].Rows[0];

                txtusername.Text = row["Name"].ToString();
                txtemail.Text = row["Email"].ToString();
                txtaddress.Text = row["Address"].ToString();
                txtmbl.Text = row["Mobile"].ToString();

                if (rdogen.Items.FindByValue(row["Gender"].ToString()) != null)
                {
                    rdogen.SelectedValue = row["Gender"].ToString();
                }

                if (drpcity.Items.FindByValue(row["City"].ToString()) != null)
                {
                    drpcity.SelectedValue = row["City"].ToString();
                }
            }
        }

        protected void Save_btn_Click(object sender, EventArgs e)
        {
            string name = txtusername.Text.Trim().Replace("'", "''");
            string email = txtemail.Text.Trim().Replace("'", "''");
            string pass = txtpassword.Text.Trim().Replace("'", "''");
            string gender = rdogen.SelectedValue;
            string city = drpcity.SelectedValue.Replace("'", "''");
            string address = txtaddress.Text.Trim().Replace("'", "''");
            string mobile = txtmbl.Text.Trim().Replace("'", "''");

            if (name == "" || email == "")
            {
                Response.Write("<script>alert('Please enter name and email')</script>");
                return;
            }

            int id = 0;
            if (Save_btn.Text == "Update")
            {
                id = Convert.ToInt32(ViewState["id"]);
            }

            // same email should not be used twice
            ds = GetData("select * from emp_tbl where Email='" + email + "' and Id <> '" + id + "'");
            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Write("<script>alert('This email is already registered')</script>");
                return;
            }

            if (Save_btn.Text == "Save")
            {
                if (pass == "")
                {
                    Response.Write("<script>alert('Please enter password')</script>");
                    return;
                }

                fileUpload();
                Execute("insert into emp_tbl(Name,Gender,Email,Password,City,Address,Mobile,Image) values('"
                    + name + "','" + gender + "','" + email + "','" + pass + "','" + city + "','" + address + "','" + mobile + "','" + fnm + "')");

                Response.Write("<script>alert('Data Inserted Successfully')</script>");
            }
            else
            {
                Execute("update emp_tbl set Name='" + name + "',Gender='" + gender + "',Email='" + email + "',City='" + city
                    + "',Address='" + address + "',Mobile='" + mobile + "' where Id='" + id + "'");

                Response.Write("<script>alert('Data Edited Successfully')</script>");
            }

            clear();

            if (Convert.ToString(Session["role"]) == "Admin")
            {
                fillGrid();
            }
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (Convert.ToString(Session["role"]) != "Admin")
            {
                return;
            }

            if (e.CommandName == "cmd_edt")
            {
                ViewState["id"] = Convert.ToInt32(e.CommandArgument);
                Save_btn.Text = "Update";
                fillData();
            }
            else if (e.CommandName == "cmd_dlt")
            {
                Execute("delete from emp_tbl where Id='" + e.CommandArgument + "'");
                fillGrid();
                Response.Write("<script>alert('Data Deleted Successfully')</script>");
            }
        }
    }
}