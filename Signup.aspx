<%@ Page Title="Sign Up" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="Shoes_Project.Signup" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>User Registration</h1>
            <p>Create and manage user accounts</p>
        </div>
    </div>

    <div class="container">
        <div class="auth-wrapper" style="max-width: 600px; margin-bottom: 40px;">
            <div class="auth-card">
                <h2>Registration Form</h2>
                <p class="auth-subtitle">Fill in user details</p>

                <div class="form-group">
                    <label for="txtusername">Name</label>
                    <asp:TextBox ID="txtusername" runat="server" CssClass="form-control" placeholder="Enter Full Name"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Gender</label>
                    <asp:RadioButtonList ID="rdogen" runat="server" RepeatDirection="Horizontal" CssClass="form-check" CellPadding="5">
                        <asp:ListItem Text="Male" Value="Male"></asp:ListItem>
                        <asp:ListItem Text="Female" Value="Female"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>

                <div class="form-group">
                    <label for="txtemail">Email Address</label>
                    <asp:TextBox ID="txtemail" runat="server" CssClass="form-control" placeholder="you@example.com"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtpassword">Password</label>
                    <asp:TextBox ID="txtpassword" runat="server" CssClass="form-control" placeholder="......" TextMode="Password"></asp:TextBox>

                </div>
                <div class="form-group">
                    <label for="drpcity">City</label>
                    <asp:DropDownList ID="drpcity" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- Select City --" Value=""></asp:ListItem>
                        <asp:ListItem Text="New York" Value="New York"></asp:ListItem>
                        <asp:ListItem Text="Los Angeles" Value="Los Angeles"></asp:ListItem>
                        <asp:ListItem Text="Chicago" Value="Chicago"></asp:ListItem>
                        <asp:ListItem Text="Houston" Value="Houston"></asp:ListItem>
                        <asp:ListItem Text="Phoenix" Value="Phoenix"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label for="txtaddress">Address</label>
                    <asp:TextBox ID="txtaddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Enter Street Address"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtmbl">Mobile</label>
                    <asp:TextBox ID="txtmbl" runat="server" CssClass="form-control" placeholder="Enter Mobile Number"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="imgupload">Profile Image</label>
                    <asp:FileUpload ID="imgupload" runat="server" CssClass="form-control" />
                </div>

                <asp:Button ID="Save_btn" runat="server" Text="Save" CssClass="btn btn-primary btn-block" OnClick="Save_btn_Click" />

                <div class="auth-footer" style="margin-top: 16px;">
                    Already have an account? <a href="Login.aspx">Sign In</a>
                </div>
            </div>
        </div>

        <!-- GridView Section -->
        <asp:Panel ID="pnlUsers" runat="server" Style="background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius); padding: 24px; overflow-x: auto;">
            <h3 style="margin-bottom: 16px;">Registered Users List</h3>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowCommand="GridView1_RowCommand" CssClass="cart-table" GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Id">
                        <ItemTemplate>
                            <asp:Label ID="Label9" runat="server" Text='<%# Eval("Id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Name">
                        <ItemTemplate>
                            <asp:Label ID="Label10" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Gender">
                        <ItemTemplate>
                            <asp:Label ID="Label11" runat="server" Text='<%# Eval("Gender") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Email">
                        <ItemTemplate>
                            <asp:Label ID="Label12" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="City">
                        <ItemTemplate>
                            <asp:Label ID="Label13" runat="server" Text='<%# Eval("City") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Address">
                        <ItemTemplate>
                            <asp:Label ID="Label14" runat="server" Text='<%# Eval("Address") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Mobile">
                        <ItemTemplate>
                            <asp:Label ID="Label15" runat="server" Text='<%# Eval("Mobile") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <asp:Image ID="Image1" runat="server" Height="50" Width="50" ImageUrl='<%# Eval("Image") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Edit">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CommandArgument='<%# Eval("Id") %>' CommandName="cmd_edt" CssClass="btn btn-sm btn-outline">Edit</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delete">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton2" runat="server" CommandArgument='<%# Eval("Id") %>' CommandName="cmd_dlt" CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Are you sure you want to delete this record?');">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField></asp:TemplateField>
                </Columns>
            </asp:GridView>
        </asp:Panel>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>