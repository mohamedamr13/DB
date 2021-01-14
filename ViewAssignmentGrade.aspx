<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewAssignmentGrade.aspx.cs" Inherits="Gucera.ViewAssignmentGrade" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style9 {
            position: absolute;
            top: 14px;
            left: 154px;
            z-index: 1;
        }
        .auto-style10 {
            position: absolute;
            top: 72px;
            left: 131px;
            z-index: 1;
        }
        .auto-style11 {
            position: absolute;
            top: 129px;
            left: 99px;
            z-index: 1;
        }
        .auto-style13 {
            position: absolute;
            top: 189px;
            left: 351px;
            z-index: 1;
        }
        </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Assignment Number<asp:TextBox ID="AssignNum" runat="server" CssClass="auto-style9"></asp:TextBox>
            <br />
            <br />
            <br />
            Assignment Type<asp:TextBox ID="AssignType" runat="server" CssClass="auto-style10"></asp:TextBox>
            <br />
            <br />
            <br />
            Course ID<asp:TextBox ID="cid" runat="server" CssClass="auto-style11"></asp:TextBox>
            <br />
            <br />
            <br />
            <asp:Button ID="view" runat="server" CssClass="auto-style13" onClick="ViewAssignGrade" Text="View Grade" />
            <br />
            <br />
            <asp:Literal ID="grd" runat="server"></asp:Literal>
            <br />
            <br />
            </div>
            <asp:Literal ID="err" runat="server"></asp:Literal>
    </form>
</body>
</html>
