<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Shoes_Project.Contactaspx" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>Contact Us</h1>
            <p>We'd love to hear from you</p>
        </div>
    </div>

    <div class="container">
        <div class="contact-grid">

            <!-- Contact Form -->
            <div class="contact-form-wrap">
                <h2>Send Us a Message</h2>
                <form data-validate class="mt-2">
                    <div class="form-group">
                        <label for="name">Your Name</label>
                        <input type="text" id="name" class="form-control" placeholder="John Doe" required />
                        <div class="form-error"></div>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" class="form-control" placeholder="you@example.com" required />
                        <div class="form-error"></div>
                    </div>
                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <input type="text" id="subject" class="form-control" placeholder="How can we help?" required />
                        <div class="form-error"></div>
                    </div>
                    <div class="form-group">
                        <label for="message">Message</label>
                        <textarea id="message" class="form-control" rows="5" placeholder="Write your message here..." required></textarea>
                        <div class="form-error"></div>
                    </div>
                    <button type="submit" class="btn btn-primary">Send Message</button>
                </form>
            </div>

            <!-- Contact Info -->
            <div class="contact-info-wrap">
                <h2>Get In Touch</h2>
                <div class="mt-2">
                    <div class="contact-info-item">
                        <div class="icon">📍</div>
                        <div>
                            <h4>Visit Us</h4>
                            <p>123 Shoe Street, Fashion City, FC 10001</p>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <div class="icon">📞</div>
                        <div>
                            <h4>Call Us</h4>
                            <p>+1 (555) 123-4567</p>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <div class="icon">✉️</div>
                        <div>
                            <h4>Email Us</h4>
                            <p>hello@shoess.com</p>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <div class="icon">🕐</div>
                        <div>
                            <h4>Business Hours</h4>
                            <p>Mon – Fri: 9AM – 6PM<br />
                                Sat – Sun: 10AM – 4PM</p>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>

