<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="Shoes_Project.Checkout" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Checkout</h1>
            <p>Check your details and place the order</p>
        </div>
    </div>

    <div class="container" style="margin-bottom:40px;">
        <div class="checkout-grid">

            <!-- Customer + Payment -->
            <div class="checkout-form">

                <asp:Label ID="lblMsg" runat="server"></asp:Label>

                <div class="checkout-section">
                    <h3>Customer Details</h3>

                    <div class="form-group">
                        <label for="txtName">Customer Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtEmail">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtMobile">Mobile</label>
                        <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtAddress">Delivery Address</label>
                        <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>

                <div class="checkout-section">
                    <h3>Payment Method</h3>
                    <div class="form-group">
                        <asp:DropDownList ID="ddlPayment" runat="server" CssClass="form-control">
                            <asp:ListItem>Cash on Delivery</asp:ListItem>
                            <asp:ListItem>Credit / Debit Card</asp:ListItem>
                            <asp:ListItem>PayPal</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <asp:Button ID="btn_place" runat="server" Text="Place Order" CssClass="btn btn-primary btn-lg btn-block" OnClick="btn_place_Click" />
                <a href="Cart.aspx" class="btn btn-outline btn-block" style="margin-top:8px;">Back to Cart</a>
            </div>

            <!-- Order Summary -->
            <div class="checkout-sidebar">
                <div class="order-summary">
                    <h3>Order Summary</h3>

                    <asp:Repeater ID="rptItems" runat="server">
                        <ItemTemplate>
                            <div class="summary-row">
                                <span><%#: Eval("Prod_Name") %> &times; <%# Eval("Quentity") %></span>
                                <span>₹<%# Convert.ToDecimal(Eval("LineTotal")).ToString("0.00") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <div class="summary-row">
                        <span>Sub Total</span>
                        <asp:Label ID="lblSubtotal" runat="server"></asp:Label>
                    </div>
                    <div class="summary-row">
                        <span>Delivery Charge</span>
                        <asp:Label ID="lblDelivery" runat="server"></asp:Label>
                    </div>
                    <div class="summary-row total">
                        <span>Grand Total</span>
                        <asp:Label ID="lblGrand" runat="server"></asp:Label>
                    </div>
                </div>
            </div>

        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
