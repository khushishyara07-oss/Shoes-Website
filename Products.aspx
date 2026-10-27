<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="Shoes_Project.Products" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Our Collection</h1>
            <p>Find the perfect pair for every step of your journey</p>
        </div>
    </div>

    <div class="container">
        <div class="products-layout">

            <!-- Filter Sidebar -->
            <aside class="filter-sidebar">
                <h3>Filters</h3>

                <div class="filter-group">
                    <h4>Company</h4>
                    <a href="Products.aspx" style="display:block;padding:4px 0;">All Companies</a>
                    <asp:Repeater ID="rptCompanyLinks" runat="server">
                        <ItemTemplate>
                            <a href='Products.aspx?company=<%# Eval("Comp_Id") %>' style="display:block;padding:4px 0;"><%#: Eval("Comp_Name") %></a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </aside>

            <!-- Product Grid: company wise -->
            <div class="products-grid">

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                    <p style="padding:24px 0;">
                        No products found. Add a company from <a href="Company.aspx">Company</a>,
                        then add products from <a href="AddProducts.aspx">Add Products</a>.
                    </p>
                </asp:Panel>

                <asp:Repeater ID="rptCompanies" runat="server" OnItemDataBound="rptCompanies_ItemDataBound">
                    <ItemTemplate>
                        <div style="margin-bottom:40px;">
                            <asp:Image ID="ImgCover" runat="server" ImageUrl='<%# Eval("Comp_Cover_Img") %>' Visible='<%# Eval("Comp_Cover_Img").ToString() != "" %>' Style="width:100%;height:160px;object-fit:cover;border-radius:8px;margin-bottom:12px;" />
                            <h2 style="margin-bottom:4px;"><%#: Eval("Comp_Name") %></h2>
                            <p class="text-muted" style="margin-bottom:16px;">
                                Owner: <%#: Eval("Comp_Owner_Name") %> &nbsp;|&nbsp; <%#: Eval("Comp_Address") %>
                            </p>

                            <div class="grid grid-3">
                                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                                    <ItemTemplate>
                                        <div class="card">
                                            <div class="card-img"><asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("Prod_Img") %>' Style="width:100%;height:100%;object-fit:cover;" /></div>
                                            <div class="card-body">
                                                <h3><%#: Eval("Prod_Name") %></h3>
                                                <p class="text-muted" style="font-size:0.85rem;margin:0 0 6px;">Model: <%#: Eval("Prod_Model") %></p>
                                                <p class="text-muted" style="font-size:0.85rem;margin:0 0 6px;"><%#: Eval("Prod_Desc") %></p>
                                                <p class="text-muted" style="font-size:0.8rem;margin:0 0 8px;">
                                                    <%#: Eval("Prod_Config") %> | <%#: Eval("Prod_Weight") %>
                                                </p>
                                                <p class="price">₹<%# Convert.ToDecimal(Eval("Prod_Price")).ToString("0.00") %></p>
                                                <asp:LinkButton ID="btnView" runat="server" CssClass="btn btn-outline btn-sm" CommandName="cmd_view" CommandArgument='<%# Eval("Prod_Id") %>'>View Details</asp:LinkButton>
                                                <asp:LinkButton ID="btnCart" runat="server" CssClass="btn btn-primary btn-sm" Visible='<%# Convert.ToString(Session["role"]) != "Admin" %>' CommandName="cmd_cart" CommandArgument='<%# Eval("Prod_Id") %>'>Add to Cart</asp:LinkButton>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

            </div>

        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>