<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewAssignmentContent.aspx.cs" Inherits="GUCera.ViewAssignmentContent" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style2 {
            position: absolute;
            top: 34px;
            left: 10px;
        }
        .auto-style4 {
            position: absolute;
            top: 124px;
            left: 12px;
            z-index: 1;
        }
        .auto-style5 {
            position: absolute;
            top: 152px;
            left: 197px;
            z-index: 1;
        }
        </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Student ID<br />
            <br />
            <br />
            <br />
            Course ID
            <asp:TextBox ID="cid" runat="server" CssClass="auto-style4"></asp:TextBox>
        </div>
        <asp:TextBox ID="sid" runat="server" CssClass="auto-style2" style="z-index: 1"></asp:TextBox>
        <p>
            <br />
        <asp:Button ID="view" runat="server" CssClass="auto-style5" onClick="ViewAssignContent" Text="Enter" />
            <br />
        </p>
        <p>
        <asp:Literal runat="server" id="msg" EnableViewState="false" />
            </p>
    </form>
</body>
</html>
