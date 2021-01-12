<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Gucera.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            position: absolute;
            top: 35px;
            left: 12px;
            z-index: 1;
        }
        .auto-style3 {
            position: absolute;
            top: 153px;
            left: 12px;
            z-index: 1;
        }
        .auto-style5 {
            position: absolute;
            top: 119px;
            left: 10px;
            z-index: 1;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:TextBox ID="username" runat="server" CssClass="auto-style1"></asp:TextBox>
            ID:<br />
        </div>
        <p>
            &nbsp;</p>
        <p>
            Password:</p>
        <p>
            <asp:TextBox ID="password" runat="server"  CssClass="auto-style5" TextMode="Password"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="submit" runat="server" CssClass="auto-style3" onClick="Login" Text="Log in" />
        </p>
    </form>
</body>
</html>
