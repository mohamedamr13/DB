<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ADViewCourses.aspx.cs" Inherits="Gucera.ADViewCourses" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style4 {
            width: 232px;
            height: 152px;
            position: absolute;
            top: 15px;
            left: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            
                
            
            
            </asp:Table>
            
                
            
            <asp:GridView ID="courseTable" runat="server" CssClass="auto-style4" style="z-index: 1" ShowHeaderWhenEmpty="True">
            </asp:GridView>
            
                
            
        </div>
    </form>
</body>
</html>
