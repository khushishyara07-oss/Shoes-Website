<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Shoes_Project.Login" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container">
        <div class="auth-wrapper">
            <div class="auth-card">
                <h2>Welcome Back</h2>
                <p class="auth-subtitle">Sign in to your account</p>

                <div class="form-group">
                    <label for="txtusername">Email Address</label>
                    <asp:TextBox ID="txtusername" runat="server" CssClass="form-control" placeholder="you@example.com"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="txtpassword">Password</label>
                    <asp:TextBox ID="txtpassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password"></asp:TextBox>
                </div>
                <div class="form-check">
                    <asp:CheckBox ID="chkRemember" runat="server" Text=" Remember me" />
                </div>
                <asp:Button ID="btnlogin" runat="server" Text="Sign In" CssClass="btn btn-primary btn-block" OnClick="btnlogin_Click" />

                <div class="auth-footer">
                    Don't have an account? <a href="Signup.aspx">Sign Up</a>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
