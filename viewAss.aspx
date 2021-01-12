<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="viewAss.aspx.cs" Inherits="Gucera.viewAss" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <br />
            Assignments</div>
        <p>
            Enter Course ID</p>
        <p>
            <asp:TextBox ID="id" runat="server"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="submit" runat="server" OnClick ="showAss" Text="View" />
        </p>
    </form>
</body>
</html>
