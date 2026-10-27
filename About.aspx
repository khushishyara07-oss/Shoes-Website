<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Shoes_Project.About" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="container">
            <h1>About Us</h1>
            <p>Our story, our passion</p>
        </div>
    </div>

    <div class="container">

        <!-- Our Story -->
        <div class="about-section">
            <div class="about-grid">
                <div class="about-img">👞</div>
                <div class="about-text">
                    <h2>Our Story</h2>
                    <p>
                        Founded in 2020, SHOESS was born from a simple belief: everyone deserves footwear that
                        doesn't compromise between style and comfort. What started as a small passion project
                        has grown into a brand trusted by thousands of customers worldwide.
                    </p>
                    <p>
                        We work directly with skilled craftsmen and innovative designers to bring you shoes
                        that look great, feel amazing, and stand the test of time. Every pair in our collection
                        is carefully curated to meet our high standards of quality and design.
                    </p>
                </div>
            </div>
        </div>

        <!-- Why Choose Us -->
        <div class="about-section">
            <div class="section-title">
                <h2>Why Choose Us</h2>
            </div>
            <div class="grid grid-3">
                <div class="feature-item">
                    <div class="feature-icon">🎨</div>
                    <h3>Curated Selection</h3>
                    <p>Every shoe in our collection is hand-picked by our design team for style, quality, and value.</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">💎</div>
                    <h3>Premium Materials</h3>
                    <p>We source only the finest leathers, fabrics, and components from trusted suppliers worldwide.</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">🤝</div>
                    <h3>Customer First</h3>
                    <p>Our dedicated support team is here to help you find the perfect fit and resolve any concerns.</p>
                </div>
            </div>
        </div>

        <!-- Our Values -->
        <div class="about-section">
            <div class="section-title">
                <h2>Our Values</h2>
            </div>
            <div class="grid grid-3">
                <div class="feature-item">
                    <div class="feature-icon">🌱</div>
                    <h3>Sustainability</h3>
                    <p>We are committed to eco-friendly practices, from packaging to production processes.</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">✊</div>
                    <h3>Fair Trade</h3>
                    <p>We ensure ethical sourcing and fair wages for everyone in our supply chain.</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">💡</div>
                    <h3>Innovation</h3>
                    <p>We continuously push boundaries with new materials and comfort technologies.</p>
                </div>
            </div>
        </div>

    </div>

</asp:Content>

<asp:Content ID="ScriptsContent" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
