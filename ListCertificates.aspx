<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ListCertificates.aspx.cs" Inherits="Milestone3.ListCertificates" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            position: absolute;
            top: 17px;
            left: 97px;
            z-index: 1;
        }
        .auto-style2 {
            position: absolute;
            top: 71px;
            left: 96px;
            z-index: 1;
        }
        .auto-style3 {
            position: absolute;
            top: 41px;
            left: 297px;
            z-index: 1;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            StudentID</div>
        <asp:TextBox ID="sid" runat="server" CssClass="auto-style1"></asp:TextBox>
        <br />
        <br />
        CourseID<asp:TextBox ID="cid" runat="server" CssClass="auto-style2"></asp:TextBox>
        <asp:Button ID="enter" runat="server" CssClass="auto-style3" OnClick="Certificates" Text="View Certificate" />
        <p>
            <asp:Literal ID="err" runat="server"></asp:Literal>
        </p>
        <asp:Literal ID="details" runat="server"></asp:Literal>
    </form>
</body>
</html>
