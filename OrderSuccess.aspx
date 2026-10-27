<%@ Page Title="Order Confirmation" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="OrderSuccess.aspx.cs" Inherits="Shoes_Project.OrderSuccess" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Order Confirmed ✅</h1>
            <p>Thank you for shopping with SHOESS!</p>
        </div>
    </div>

    <div class="container" style="margin-bottom:40px;">
        <div class="checkout-grid">

            <div class="checkout-form">

                <div class="checkout-section">
                    <h3>Order Details</h3>
                    <div class="summary-row"><span>Order No</span><asp:Label ID="lblOrderNo" runat="server"></asp:Label></div>
                    <div class="summary-row"><span>Order Date</span><asp:Label ID="lblOrderDate" runat="server"></asp:Label></div>
                    <div class="summary-row"><span>Customer Name</span><asp:Label ID="lblCustName" runat="server"></asp:Label></div>
                    <div class="summary-row"><span>Email</span><asp:Label ID="lblEmail" runat="server"></asp:Label></div>
                    <div class="summary-row"><span>Mobile</span><asp:Label ID="lblMobile" runat="server"></asp:Label></div>
                    <div class="summary-row"><span>Address</span><asp:Label ID="lblAddress" runat="server"></asp:Label></div>
                </div>

                <div class="checkout-section" style="overflow-x:auto;">
                    <h3>Items</h3>
                    <asp:GridView ID="GridView1" runat="server" CssClass="cart-table" GridLines="None" AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="Product">
                                <ItemTemplate>
                                    <div class="cart-item-info">
                                        <div class="cart-item-thumb"><asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("Item_Img") %>' Style="width:100%;height:100%;object-fit:cover;" /></div>
                                        <div><strong><%#: Eval("Item_Name") %></strong></div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Quantity">
                                <ItemTemplate><%# Eval("Item_Qty") %></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Price">
                                <ItemTemplate>₹<%# Convert.ToDecimal(Eval("Item_Price")).ToString("0.00") %></ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

            </div>

            <div class="checkout-sidebar">
                <div class="order-summary">
                    <h3>Payment Summary</h3>
                    <div class="summary-row"><span>Sub Total</span><asp:Label ID="lblSubTotal" runat="server"></asp:Label></div>
                    <div class="summary-row"><span>Delivery Charge</span><asp:Label ID="lblDelivery" runat="server"></asp:Label></div>
                    <div class="summary-row total"><span>Grand Total</span><asp:Label ID="lblGrandTotal" runat="server"></asp:Label></div>
                    <div class="summary-row"><span>Payment Method</span><asp:Label ID="lblPayMode" runat="server"></asp:Label></div>
                    <div class="summary-row"><span>Payment Status</span><asp:Label ID="lblPayStatus" runat="server"></asp:Label></div>
                    <a href="Products.aspx" class="btn btn-primary btn-block mt-2">Continue Shopping</a>
                </div>
            </div>

        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
