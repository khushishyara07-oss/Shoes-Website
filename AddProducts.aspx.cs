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
    public partial class AddProducts : Page
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
                LoadCompanies();
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

        void LoadCompanies()
        {
            ds = GetData("select Comp_Id, Comp_Name from Add_Company_Tbl order by Comp_Name");

            ddlCompany.DataSource = ds.Tables[0];
            ddlCompany.DataTextField = "Comp_Name";
            ddlCompany.DataValueField = "Comp_Id";
            ddlCompany.DataBind();

            ddlCompany.Items.Insert(0, new ListItem("-- Select Company --", ""));

            pnlNoCompany.Visible = (ds.Tables[0].Rows.Count == 0);
        }

        void BindGrid()
        {
            gvProduct.DataSource = GetData(
                "select p.*, c.Comp_Name from Add_Products_Tbl p " +
                "inner join Add_Company_Tbl c on c.Comp_Id = p.Prod_Comp_Id " +
                "order by c.Comp_Name, p.Prod_Name");
            gvProduct.DataBind();
        }

        void ResetForm()
        {
            ddlCompany.SelectedIndex = 0;
            txtProductName.Text = "";
            txtModel.Text = "";
            txtPrice.Text = "";
            txtWeight.Text = "";
            txtConfig.Text = "";
            txtDesc.Text = "";
            ViewState["id"] = null;
            btnSave.Text = "Save Product";
            btnCancel.Visible = false;
        }

        string SaveImage()
        {
            if (!fuImage.HasFile)
            {
                return "";
            }

            Directory.CreateDirectory(Server.MapPath("~/images"));
            string file = DateTime.Now.Ticks + "_" + Path.GetFileName(fuImage.FileName).Replace(" ", "_").Replace("'", "");
            fuImage.SaveAs(Server.MapPath("~/images/" + file));
            return "images/" + file;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (ddlCompany.SelectedValue == "")
            {
                Msg("Please select a company.", false);
                return;
            }

            string name = txtProductName.Text.Trim().Replace("'", "''");
            string model = txtModel.Text.Trim().Replace("'", "''");
            string price = txtPrice.Text.Trim();
            string weight = txtWeight.Text.Trim().Replace("'", "''");
            string config = txtConfig.Text.Trim().Replace("'", "''");
            string desc = txtDesc.Text.Trim().Replace("'", "''");

            if (name == "")
            {
                Msg("Please enter product name.", false);
                return;
            }

            decimal p;
            if (!decimal.TryParse(price, out p))
            {
                Msg("Please enter a valid price.", false);
                return;
            }

            if (fuImage.HasFile)
            {
                string ext = Path.GetExtension(fuImage.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".webp" && ext != ".jfif")
                {
                    Msg("Only image files are allowed.", false);
                    return;
                }
            }

            string img = SaveImage();

            if (ViewState["id"] == null)
            {
                Execute("insert into Add_Products_Tbl(Prod_Comp_Id,Prod_Name,Prod_Desc,Prod_Model,Prod_Price,Prod_Config,Prod_Weight,Prod_Img) values('"
                    + ddlCompany.SelectedValue + "','" + name + "','" + desc + "','" + model + "','" + price + "','" + config + "','" + weight + "','" + img + "')");

                Msg("Product added successfully.", true);
            }
            else
            {
                string query = "update Add_Products_Tbl set Prod_Comp_Id='" + ddlCompany.SelectedValue +
                               "',Prod_Name='" + name + "',Prod_Desc='" + desc + "',Prod_Model='" + model +
                               "',Prod_Price='" + price + "',Prod_Config='" + config + "',Prod_Weight='" + weight + "'";

                if (img != "")
                {
                    query += ",Prod_Img='" + img + "'";
                }

                query += " where Prod_Id='" + ViewState["id"] + "'";

                Execute(query);
                Msg("Product updated successfully.", true);
            }

            ResetForm();
            BindGrid();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
            lblMsg.Text = "";
        }

        protected void gvProduct_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "cmd_edt")
            {
                ds = GetData("select * from Add_Products_Tbl where Prod_Id='" + id + "'");

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow row = ds.Tables[0].Rows[0];

                    ddlCompany.SelectedValue = row["Prod_Comp_Id"].ToString();
                    txtProductName.Text = row["Prod_Name"].ToString();
                    txtModel.Text = row["Prod_Model"].ToString();
                    txtPrice.Text = row["Prod_Price"].ToString();
                    txtWeight.Text = row["Prod_Weight"].ToString();
                    txtConfig.Text = row["Prod_Config"].ToString();
                    txtDesc.Text = row["Prod_Desc"].ToString();

                    ViewState["id"] = id;
                    btnSave.Text = "Update Product";
                    btnCancel.Visible = true;
                    lblMsg.Text = "";
                }
            }
            else if (e.CommandName == "cmd_dlt")
            {
                Execute("delete from Add_Products_Tbl where Prod_Id='" + id + "'");

                ResetForm();
                BindGrid();
                Msg("Product deleted successfully.", true);
            }
        }
    }
}