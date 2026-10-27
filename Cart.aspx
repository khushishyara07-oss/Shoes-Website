<%@ Page Title="Cart" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="Shoes_Project.Cart" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Shopping Cart</h1>
            <p><asp:Label ID="lblWelcome" runat="server"></asp:Label></p>
        </div>
    </div>

    <div class="container" style="margin-bottom:40px;">

        <!-- Empty Cart -->
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="empty-state">
                <div class="icon">🛒</div>
                <h3>Your cart is empty</h3>
                <p>Looks like you haven't added any shoes yet. Start exploring our collection!</p>
                <a href="Products.aspx" class="btn btn-primary">Browse Products</a>
            </div>
        </asp:Panel>

        <!-- Cart Content -->
        <asp:Panel ID="pnlCart" runat="server">
            <div class="checkout-grid">

                <div class="checkout-form" style="overflow-x:auto;">
                    <asp:GridView ID="GridView1" runat="server" CssClass="cart-table" GridLines="None"
                        AutoGenerateColumns="False" DataKeyNames="Prod_Id"
                        OnRowCommand="GridView1_RowCommand"
                        OnRowEditing="GridView1_RowEditing"
                        OnRowUpdating="GridView1_RowUpdating"
                        OnRowCancelingEdit="GridView1_RowCancelingEdit">
                        <Columns>

                            <asp:TemplateField HeaderText="Product">
                                <ItemTemplate>
                                    <div class="cart-item-info">
                                        <div class="cart-item-thumb"><asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("Prod_Img") %>' Style="width:100%;height:100%;object-fit:cover;" /></div>
                                        <div>
                                            <strong><%#: Eval("Prod_Name") %></strong><br />
                                            <span class="text-muted" style="font-size:0.8rem;"><%#: Eval("Prod_Model") %></span>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Price">
                                <ItemTemplate>₹<%# Convert.ToDecimal(Eval("Prod_Price")).ToString("0.00") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Quantity">
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# Eval("Quentity") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" Style="width:80px;">
                                        <asp:ListItem Value="1">1</asp:ListItem>
                                        <asp:ListItem Value="2">2</asp:ListItem>
                                        <asp:ListItem Value="3">3</asp:ListItem>
                                        <asp:ListItem Value="4">4</asp:ListItem>
                                        <asp:ListItem Value="5">5</asp:ListItem>
                                        <asp:ListItem Value="6">6</asp:ListItem>
                                        <asp:ListItem Value="7">7</asp:ListItem>
                                        <asp:ListItem Value="8">8</asp:ListItem>
                                        <asp:ListItem Value="9">9</asp:ListItem>
                                        <asp:ListItem Value="10">10</asp:ListItem>
                                    </asp:DropDownList>
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Total">
                                <ItemTemplate>₹<%# Convert.ToDecimal(Eval("LineTotal")).ToString("0.00") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:CommandField HeaderText="Change Qty" ShowEditButton="True"
                                EditText="Change" UpdateText="Save" CancelText="Cancel" />

                            <asp:TemplateField HeaderText="Remove">
                                <ItemTemplate>
                                    <asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="btn btn-danger btn-sm"
                                        CommandName="cmd_remove" CommandArgument='<%# Eval("Cart_Id") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>

                <div class="checkout-sidebar">
                    <div class="order-summary">
                        <h3>Order Summary</h3>
                        <div class="summary-row">
                            <span>Subtotal</span>
                            <asp:Label ID="lblSubtotal" runat="server"></asp:Label>
                        </div>
                        <div class="summary-row">
                            <span>Delivery Charge</span>
                            <asp:Label ID="lblDelivery" runat="server"></asp:Label>
                        </div>
                        <div class="summary-row total">
                            <span>Grand Total</span>
                            <asp:Label ID="grand_total" runat="server"></asp:Label>
                        </div>
                        <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Checkout" CssClass="btn btn-primary btn-block mt-2" OnClick="btnCheckout_Click" />
                    </div>
                </div>

            </div>
        </asp:Panel>

    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
