<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Shoes_Project.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Step Into Style</h1>
            <p>Premium footwear crafted for comfort, designed for life. Discover your perfect pair today.</p>
            <a href="Products.aspx" class="btn btn-white btn-lg">Shop Collection</a>
        </div>
    </section>

    <!-- Featured Collection -->
    <section class="container">
        <div class="section-title">
            <h2>Featured Collection</h2>
            <p>Handpicked styles for every occasion</p>
        </div>
        <asp:Panel ID="pnlNoFeatured" runat="server" Visible="false">
            <p class="text-center text-muted">No products yet. Add a company and products from the menu after login.</p>
        </asp:Panel>
        <div class="grid grid-4">
            <asp:Repeater ID="rptFeatured" runat="server" OnItemCommand="rptFeatured_ItemCommand">
                <ItemTemplate>
                    <div class="card">
                        <div class="card-img"><asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("Prod_Img") %>' Style="width:100%;height:100%;object-fit:cover;" /></div>
                        <div class="card-body">
                            <h3><%#: Eval("Prod_Name") %></h3>
                            <p class="price">₹<%# Convert.ToDecimal(Eval("Prod_Price")).ToString("0.00") %></p>
                            <asp:LinkButton ID="btnView" runat="server" CssClass="btn btn-outline btn-sm" CommandName="cmd_view" CommandArgument='<%# Eval("Prod_Id") %>'>View Details</asp:LinkButton>
                            <asp:LinkButton ID="btnCart" runat="server" CssClass="btn btn-primary btn-sm" Visible='<%# Convert.ToString(Session["role"]) != "Admin" %>' CommandName="cmd_cart" CommandArgument='<%# Eval("Prod_Id") %>'>Add to Cart</asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </section>

    <!-- Features -->
    <section class="features">
        <div class="container">
            <div class="grid grid-3">
                <div class="feature-item">
                    <div class="feature-icon">🚚</div>
                    <h3>Free Shipping</h3>
                    <p>Free delivery on all orders over ₹1000. No hidden charges.</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">✨</div>
                    <h3>Premium Quality</h3>
                    <p>Crafted from the finest materials for lasting comfort and durability.</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">🔄</div>
                    <h3>Easy Returns</h3>
                    <p>30-day hassle-free return policy. No questions asked.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Newsletter -->
    <section class="newsletter">
        <div class="container">
            <h2>Stay in the Loop</h2>
            <p>Subscribe to get updates on new arrivals and exclusive offers.</p>
            <form class="newsletter-form" data-validate>
                <input type="email" class="form-control" placeholder="Enter your email" required />
                <button type="submit" class="btn btn-primary">Subscribe</button>
            </form>
        </div>
    </section>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
