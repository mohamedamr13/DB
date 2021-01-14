<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="instrHome.aspx.cs" Inherits="Gucera.instrHome" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Instructor Dashboard
        </div>
        <p>
            Add Course</p>
        <p>
            <asp:Button ID="AddCourse" runat="server" onClick="addCourse" Text="ADD" />
        </p>
        <p>
            View all Courses
        </p>
        <p>
            <asp:Button ID="ViewCourses" runat="server" onClick="viewCourses" Text="VIEW" />
        </p>
    </form>
</body>
</html>
