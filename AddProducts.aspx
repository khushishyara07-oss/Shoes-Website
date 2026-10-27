<%@ Page Title="Add Products" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AddProducts.aspx.cs" Inherits="Shoes_Project.AddProducts" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Manage Products</h1>
            <p>Select a company and add its products</p>
        </div>
    </div>

    <div class="container">
        <div class="auth-wrapper" style="max-width: 600px; margin-bottom: 40px;">
            <div class="auth-card">
                <h2>Product Form</h2>
                <p class="auth-subtitle">Enter product details</p>

                <asp:Label ID="lblMsg" runat="server"></asp:Label>

                <asp:Panel ID="pnlNoCompany" runat="server" Visible="false">
                    <div style="padding:10px 14px;margin-bottom:16px;border-radius:6px;color:#92400e;background:#fef3c7;">
                        No company found. Please <a href="Company.aspx"><strong>add a company</strong></a> first.
                    </div>
                </asp:Panel>

                <div class="form-group">
                    <label for="ddlCompany">Company</label>
                    <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>

                <div class="form-group">
                    <label for="txtProductName">Product Name</label>
                    <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" placeholder="e.g. Air Runner"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtModel">Model</label>
                    <asp:TextBox ID="txtModel" runat="server" CssClass="form-control" placeholder="e.g. AR-2026"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtPrice">Price (₨)</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" placeholder="e.g. 89.99"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtWeight">Weight</label>
                    <asp:TextBox ID="txtWeight" runat="server" CssClass="form-control" placeholder="e.g. 350 g"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtConfig">Configuration</label>
                    <asp:TextBox ID="txtConfig" runat="server" CssClass="form-control" placeholder="e.g. Size 6-11, Mesh upper"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtDesc">Description</label>
                    <asp:TextBox ID="txtDesc" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Short description"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="fuImage">Product Image</label>
                    <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                </div>

                <asp:Button ID="btnSave" runat="server" Text="Save Product" CssClass="btn btn-primary btn-block" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel Edit" CssClass="btn btn-outline btn-block" Style="margin-top: 8px;" Visible="false" OnClick="btnCancel_Click" />

                <div class="auth-footer" style="margin-top: 16px;">
                    Need another company? <a href="Company.aspx">Add Company</a>
                </div>
            </div>
        </div>

        <div style="background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius); padding: 24px; overflow-x: auto; margin-bottom: 40px;">
            <h3 style="margin-bottom: 16px;">Product List</h3>
            <asp:GridView ID="gvProduct" runat="server" AutoGenerateColumns="False" OnRowCommand="gvProduct_RowCommand" CssClass="cart-table" GridLines="None" EmptyDataText="No products yet.">
                <Columns>
                    <asp:BoundField DataField="Prod_Id" HeaderText="Id" />
                    <asp:BoundField DataField="Comp_Name" HeaderText="Company" />
                    <asp:BoundField DataField="Prod_Name" HeaderText="Product" />
                    <asp:BoundField DataField="Prod_Model" HeaderText="Model" />
                    <asp:BoundField DataField="Prod_Price" HeaderText="Price" />
                    <asp:BoundField DataField="Prod_Weight" HeaderText="Weight" />
                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <asp:Image ID="imgProd" runat="server" Height="50" Width="50" ImageUrl='<%# Eval("Prod_Img") %>' Visible='<%# Convert.ToString(Eval("Prod_Img")) != "" %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Edit">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CommandArgument='<%# Eval("Prod_Id") %>' CommandName="cmd_edt" CssClass="btn btn-sm btn-outline">Edit</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delete">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandArgument='<%# Eval("Prod_Id") %>' CommandName="cmd_dlt" CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Delete this product?');">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>