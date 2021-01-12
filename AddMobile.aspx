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
            bottom: 206px;
            right: 843px;
            height: 29px;
        }
        .auto-style2 {
            position: absolute;
            top: 53px;
            left: 16px;
            z-index: 1;
            width: 168px;
        }
        .auto-style3 {
            position: absolute;
            top: 48px;
            left: 393px;
            z-index: 1;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            please add your mobile number :<br />
&nbsp;<asp:TextBox ID="mobile" runat="server" CssClass="auto-style2" TextMode="Phone"></asp:TextBox>
        </div>
        <asp:Button ID="add" runat="server" CssClass="auto-style1"  onClick="onSave" Text="Save" />
        <asp:Button ID="more" runat="server" CssClass="auto-style3" OnClick="addMoreMob" Text="Add more" />
        <p>
            &nbsp;</p>
    </form>
</body>
</html>
