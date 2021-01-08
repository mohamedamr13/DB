<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddMobile.aspx.cs" Inherits="Gucera.AddMobile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            position: absolute;
            top: 49px;
            left: 246px;
            z-index: 1;
            bottom: 208px;
            right: 843px;
        }
        .auto-style2 {
            position: absolute;
            top: 53px;
            left: 16px;
            z-index: 1;
            width: 168px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            please add your mobile number(s):<br />
&nbsp;<asp:TextBox ID="mobile" runat="server" CssClass="auto-style2" TextMode="Phone"></asp:TextBox>
        </div>
        <asp:Button ID="add" runat="server" CssClass="auto-style1"  onClick="onSave" Text="Save" Height="20px" />
    </form>
</body>
</html>
