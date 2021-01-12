
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Gucera.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            position: absolute;
            top: 45px;
            left: 10px;
            z-index: 1;
            right: 965px;
        }
        .auto-style2 {
            position: absolute;
            top: 49px;
            left: 316px;
            z-index: 1;
        }
        .auto-style3 {
            position: absolute;
            top: 429px;
            left: 263px;
            z-index: 1;
        }
        .auto-style6 {
            position: absolute;
            top: 126px;
            left: 316px;
            z-index: 1;
        }
        .auto-style9 {
            position: absolute;
            top: 239px;
            left: 11px;
            z-index: 1;
            width: 76px;
            height: 28px;
        }
        .auto-style10 {
            position: absolute;
            top: 271px;
            left: 6px;
            z-index: 1;
            height: 28px;
            bottom: 188px;
        }
        .auto-style12 {
            width: 96px;
            height: 28px;
            position: absolute;
            top: 191px;
            left: 82px;
            z-index: 1;
        }
        .auto-style13 {
            width: 134px;
            height: 28px;
            position: absolute;
            top: 367px;
            left: 41px;
            z-index: 1;
            margin-bottom: 1px;
        }
        .auto-style14 {
            position: absolute;
            top: 124px;
            left: 5px;
            z-index: 1;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            First Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Last Name:<br />
            <asp:TextBox ID="fName" runat="server" CssClass="auto-style1"></asp:TextBox>
            <br />
            <br />
            <br />
            Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e-mail:<br />
            
            <asp:TextBox ID="password" runat="server" CssClass="auto-style14" TextMode="Password"></asp:TextBox>
            <br />
            <asp:TextBox ID="email" runat="server" CssClass="auto-style6"></asp:TextBox>
            <br />
            <br />
            Gender:<br />
            <asp:Label ID="LabelAddress" runat="server" CssClass="auto-style9" Text="address:"></asp:Label>
            <asp:RadioButtonList ID="gender" runat="server" CssClass="auto-style12">
                <asp:ListItem>Female</asp:ListItem>
                <asp:ListItem>Male</asp:ListItem>
            </asp:RadioButtonList>
            <br />
            <asp:TextBox ID="lName" runat="server" CssClass="auto-style2"></asp:TextBox>
            <br />
            <asp:TextBox ID="address" runat="server" CssClass="auto-style10"></asp:TextBox>
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            Role:<br />
            <asp:RadioButtonList ID="role" runat="server" CssClass="auto-style13">
                <asp:ListItem>Student</asp:ListItem>
                <asp:ListItem>Instructor</asp:ListItem>
            </asp:RadioButtonList>
            <br />
            <br />
            <asp:Button ID="submit" runat="server" CssClass="auto-style3"  onClick="register" Text="Register" />
        </div>
    </form>
</body>
</html>
