<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreatePromo.aspx.cs" Inherits="Gucera.CreatePromo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            position: absolute;
            top: 16px;
            left: 78px;
            z-index: 1;
        }
        .auto-style2 {
            position: absolute;
            top: 43px;
            left: 483px;
            z-index: 1;
            width: 175px;
        }
        .auto-style3 {
            position: absolute;
            top: 84px;
            left: 488px;
            z-index: 1;
        }
        .auto-style4 {
            position: absolute;
            top: 120px;
            left: 96px;
            z-index: 1;
        }
        </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Code:<asp:TextBox ID="code" runat="server" CssClass="auto-style1"></asp:TextBox>
            <br />
            <br />
            Issue Date :*Please write the date in MM/DD/YYYY&nbsp;
            <asp:TextBox ID="IssueDate" runat="server" CssClass="auto-style2" TextMode="DateTime"></asp:TextBox>
            <br />
            <br />
            Expiry Date : *Please write the date in MM/DD/YYYY
            <asp:TextBox ID="expDate" runat="server" CssClass="auto-style3" TextMode="DateTime"></asp:TextBox>
            <br />
            <br />
            Discount :
            <asp:TextBox ID="discount" runat="server" CssClass="auto-style4"></asp:TextBox>
            <br />
            <asp:Button ID="create" runat="server" CssClass="auto-style5" onClick="CreatePromoCode" Text="Create" />
        </div>
    </form>
</body>
</html>
