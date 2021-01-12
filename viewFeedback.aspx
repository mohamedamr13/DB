<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="viewFeedback.aspx.cs" Inherits="Gucera.viewFeedback" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Feedbacks</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Course Feedbacks</div>
    <p>
    </p>
        <p>
            Course ID
    </p>
        <asp:TextBox ID="cc" runat="server"></asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="submit" runat="server" OnClick ="getFeedback" Text="Submit" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </form>
    </body>
</html>
