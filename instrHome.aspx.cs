using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Gucera
{
    public partial class instrHome : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void addCourse(object sender, EventArgs e)
        {
            Response.Redirect("addCourse.aspx");
        }


        protected void viewCourses(object sender, EventArgs e)
        {
            Response.Redirect("viewCourses.aspx");
        }


    }
}