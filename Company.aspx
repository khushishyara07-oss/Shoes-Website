<%@ Page Title="Company" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Company.aspx.cs" Inherits="Shoes_Project.Company" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Manage Companies</h1>
            <p>Step 1: add a company. Step 2: add products to it.</p>
        </div>
    </div>

    <div class="container">
        <div class="auth-wrapper" style="max-width: 600px; margin-bottom: 40px;">
            <div class="auth-card">
                <h2>Company Form</h2>
                <p class="auth-subtitle">Enter company details</p>

                <asp:Label ID="lblMsg" runat="server"></asp:Label>

                <div class="form-group">
                    <label for="txtCompanyName">Company Name</label>
                    <asp:TextBox ID="txtCompanyName" runat="server" CssClass="form-control" placeholder="e.g. Nike"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtOwner">Owner Name</label>
                    <asp:TextBox ID="txtOwner" runat="server" CssClass="form-control" placeholder="Owner full name"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtEmail">Company Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="company@example.com"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtAddress">Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Company address"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="fuCover">Cover Image (optional)</label>
                    <asp:FileUpload ID="fuCover" runat="server" CssClass="form-control" />
                </div>

                <asp:Button ID="btnSave" runat="server" Text="Save Company" CssClass="btn btn-primary btn-block" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel Edit" CssClass="btn btn-outline btn-block" Style="margin-top: 8px;" Visible="false" OnClick="btnCancel_Click" />

                <div class="auth-footer" style="margin-top: 16px;">
                    Company added? <a href="AddProducts.aspx">Add Products</a>
                </div>
            </div>
        </div>

        <div style="background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius); padding: 24px; overflow-x: auto; margin-bottom: 40px;">
            <h3 style="margin-bottom: 16px;">Company List</h3>
            <asp:GridView ID="gvCompany" runat="server" AutoGenerateColumns="False" OnRowCommand="gvCompany_RowCommand" CssClass="cart-table" GridLines="None" EmptyDataText="No companies yet. Add your first company above.">
                <Columns>
                    <asp:BoundField DataField="Comp_Id" HeaderText="Id" />
                    <asp:BoundField DataField="Comp_Name" HeaderText="Company" />
                    <asp:BoundField DataField="Comp_Owner_Name" HeaderText="Owner" />
                    <asp:BoundField DataField="Comp_Email" HeaderText="Email" />
                    <asp:BoundField DataField="Comp_Address" HeaderText="Address" />
                    <asp:TemplateField HeaderText="Cover">
                        <ItemTemplate>
                            <asp:Image ID="imgCover" runat="server" Height="50" Width="50" ImageUrl='<%# Eval("Comp_Cover_Img") %>' Visible='<%# Convert.ToString(Eval("Comp_Cover_Img")) != "" %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ProductCount" HeaderText="Products" />
                    <asp:TemplateField HeaderText="View">
                        <ItemTemplate>
                            <a class="btn btn-sm btn-outline" href='Products.aspx?company=<%# Eval("Comp_Id") %>'>Products</a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Edit">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CommandArgument='<%# Eval("Comp_Id") %>' CommandName="cmd_edt" CssClass="btn btn-sm btn-outline">Edit</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delete">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandArgument='<%# Eval("Comp_Id") %>' CommandName="cmd_dlt" CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Delete this company AND all its products?');">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>