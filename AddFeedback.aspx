<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddFeedback.aspx.cs" Inherits="Gucera.AddFeedback" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            position: absolute;
            top: 15px;
            left: 10px;
        }
        .auto-style2 {
            position: absolute;
            top: 34px;
            left: 10px;
        }
        .auto-style3 {
            position: absolute;
            top: 74px;
            left: 12px;
            z-index: 1;
        }
        .auto-style4 {
            position: absolute;
            top: 99px;
            left: 11px;
            z-index: 1;
            height: 17px;
        }
        .auto-style7 {
            position: absolute;
            top: 60px;
            left: 203px;
            z-index: 1;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="comm" runat="server" CssClass="auto-style1" style="z-index: 1" Text="Comment"></asp:Label>
        </div>
        <asp:TextBox ID="comt" runat="server" CssClass="auto-style2" style="z-index: 1"></asp:TextBox>
        <asp:Label ID="id1" runat="server" CssClass="auto-style3" Text="CourseID"></asp:Label>
        <asp:TextBox ID="cid" runat="server" CssClass="auto-style4"></asp:TextBox>
        <asp:Button ID="feedback" runat="server" CssClass="auto-style7" OnClick="Feedback" Text="Enter" />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <asp:Literal ID="err" runat="server"></asp:Literal>
        <br />
        <asp:Literal ID="succ" runat="server"></asp:Literal>
    </form>
</body>
</html>
