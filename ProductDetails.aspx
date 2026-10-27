<%@ Page Title="Product Details" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="Shoes_Project.ProductDetails" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Product Details</h1>
            <p><a href="Products.aspx">&larr; Back to Products</a></p>
        </div>
    </div>

    <div class="container" style="margin-bottom:40px;">

        <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
            <p style="padding:24px 0;">Product not found. <a href="Products.aspx">Browse products</a></p>
        </asp:Panel>

        <asp:Repeater ID="rptDetails" runat="server" OnItemCommand="rptDetails_ItemCommand">
            <ItemTemplate>
                <div class="checkout-grid">
                    <div class="checkout-form" style="max-width:420px;">
                        <div class="card-img" style="height:360px;"><asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("Prod_Img") %>' Style="width:100%;height:100%;object-fit:cover;" /></div>
                    </div>
                    <div class="checkout-sidebar">
                        <h2 style="margin-bottom:4px;"><%#: Eval("Prod_Name") %></h2>
                        <p class="text-muted">by <%#: Eval("Comp_Name") %> &nbsp;|&nbsp; Model: <%#: Eval("Prod_Model") %></p>
                        <p class="price" style="font-size:1.6rem;">₹<%# Convert.ToDecimal(Eval("Prod_Price")).ToString("0.00") %></p>
                        <p><strong>Weight:</strong> <%#: Eval("Prod_Weight") %></p>
                        <p><strong>Configuration:</strong> <%#: Eval("Prod_Config") %></p>
                        <p><%#: Eval("Prod_Desc") %></p>
                        <asp:LinkButton ID="btnCart" runat="server" CssClass="btn btn-primary btn-lg" Visible='<%# Convert.ToString(Session["role"]) != "Admin" %>' CommandName="cmd_cart" CommandArgument='<%# Eval("Prod_Id") %>'>Add to Cart</asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
