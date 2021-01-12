<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IssuePromo.aspx.cs" Inherits="Gucera.IssuePromo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            position: absolute;
            top: 56px;
            left: 10px;
        }
        .auto-style2 {
            position: absolute;
            top: 119px;
            left: 10px;
        }
        .auto-style3 {
            position: absolute;
            top: 160px;
            left: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <p>
            Promo code ID :</p>
        <asp:TextBox ID="pid" runat="server" CssClass="auto-style1" style="z-index: 1"></asp:TextBox>
        <br />
        <br />
        Student ID :<p>
            <asp:TextBox ID="sid" runat="server" CssClass="auto-style2" style="z-index: 1"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="issue" runat="server" CssClass="auto-style3" style="z-index: 1" OnClick="issuePromocode" Text="Issue" />
        </p>
    </form>
</body>
</html>
