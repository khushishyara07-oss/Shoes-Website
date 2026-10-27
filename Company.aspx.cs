using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Shoes_Project
{
    public partial class Company : Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["user"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // only admin can open this page
            if (Convert.ToString(Session["role"]) != "Admin")
            {
                Response.Redirect("Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        void Msg(string text, bool ok)
        {
            string color = ok ? "#166534" : "#b91c1c";
            string bg = ok ? "#dcfce7" : "#fee2e2";
            lblMsg.Text = "<div style='padding:10px 14px;margin-bottom:16px;border-radius:6px;color:" + color +
                          ";background:" + bg + ";'>" + HttpUtility.HtmlEncode(text) + "</div>";
        }

        void BindGrid()
        {
            gvCompany.DataSource = GetData(
                "select c.*, (select count(*) from Add_Products_Tbl p where p.Prod_Comp_Id = c.Comp_Id) as ProductCount " +
                "from Add_Company_Tbl c order by c.Comp_Name");
            gvCompany.DataBind();
        }

        void ResetForm()
        {
            txtCompanyName.Text = "";
            txtOwner.Text = "";
            txtEmail.Text = "";
            txtAddress.Text = "";
            ViewState["id"] = null;
            btnSave.Text = "Save Company";
            btnCancel.Visible = false;
        }

        string SaveImage()
        {
            if (!fuCover.HasFile)
            {
                return "";
            }

            Directory.CreateDirectory(Server.MapPath("~/images"));
            string file = DateTime.Now.Ticks + "_" + Path.GetFileName(fuCover.FileName).Replace(" ", "_").Replace("'", "");
            fuCover.SaveAs(Server.MapPath("~/images/" + file));
            return "images/" + file;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string name = txtCompanyName.Text.Trim().Replace("'", "''");
            string owner = txtOwner.Text.Trim().Replace("'", "''");
            string email = txtEmail.Text.Trim().Replace("'", "''");
            string address = txtAddress.Text.Trim().Replace("'", "''");

            if (name == "")
            {
                Msg("Please enter company name.", false);
                return;
            }

            if (fuCover.HasFile)
            {
                string ext = Path.GetExtension(fuCover.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".webp" && ext != ".jfif")
                {
                    Msg("Only image files are allowed.", false);
                    return;
                }
            }

            string img = SaveImage();

            if (ViewState["id"] == null)
            {
                Execute("insert into Add_Company_Tbl(Comp_Name,Comp_Email,Comp_Address,Comp_Cover_Img,Comp_Owner_Name) values('"
                    + name + "','" + email + "','" + address + "','" + img + "','" + owner + "')");

                Msg("Company added successfully.", true);
            }
            else
            {
                string query = "update Add_Company_Tbl set Comp_Name='" + name + "',Comp_Email='" + email +
                               "',Comp_Address='" + address + "',Comp_Owner_Name='" + owner + "'";

                if (img != "")
                {
                    query += ",Comp_Cover_Img='" + img + "'";
                }

                query += " where Comp_Id='" + ViewState["id"] + "'";

                Execute(query);
                Msg("Company updated successfully.", true);
            }

            ResetForm();
            BindGrid();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
            lblMsg.Text = "";
        }

        protected void gvCompany_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "cmd_edt")
            {
                ds = GetData("select * from Add_Company_Tbl where Comp_Id='" + id + "'");

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];

                    txtCompanyName.Text = row["Comp_Name"].ToString();
                    txtOwner.Text = row["Comp_Owner_Name"].ToString();
                    txtEmail.Text = row["Comp_Email"].ToString();
                    txtAddress.Text = row["Comp_Address"].ToString();

                    ViewState["id"] = id;
                    btnSave.Text = "Update Company";
                    btnCancel.Visible = true;
                    lblMsg.Text = "";
                }
            }
            else if (e.CommandName == "cmd_dlt")
            {
                Execute("delete from Add_Products_Tbl where Prod_Comp_Id='" + id + "'");
                Execute("delete from Add_Company_Tbl where Comp_Id='" + id + "'");

                ResetForm();
                BindGrid();
                Msg("Company deleted successfully.", true);
            }
        }
    }
}