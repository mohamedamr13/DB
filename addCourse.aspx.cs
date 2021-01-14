using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Gucera
{
    public partial class addCourse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }


        protected void SubmitCourse(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);


          
            try
            {

                String name = cName.Text;
                if (!checkLength(name, 10))
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Maximum Course Name length is 10')", true);
                else
                {
                    float cPrice = float.Parse(Price.Text);
                    int creditHours = Int16.Parse(credit.Text);
                    int id = (int)Session["user"];
                    SqlCommand insAddCourse = new SqlCommand("InstAddCourse", conn);
                    insAddCourse.CommandType = CommandType.StoredProcedure;


                    insAddCourse.Parameters.Add(new SqlParameter("@name", name));
                    insAddCourse.Parameters.Add(new SqlParameter("@creditHours", creditHours));
                    insAddCourse.Parameters.Add(new SqlParameter("@price", cPrice));
                    insAddCourse.Parameters.Add(new SqlParameter("@instructorId", id));


                    conn.Open();
                    insAddCourse.ExecuteNonQuery();
                    conn.Close();

                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('New Course added .. Awaiting approval from Admin')", true);
                }
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Please enter all required data correctly')", true);
            }



        }

        protected void Dash(object sender, EventArgs e)
        {
            Response.Redirect("instrHome.aspx");

        }

        public Boolean checkLength( String s , int n)
        {
            if (s.Length <= n)
                return true;
            else
                return false;
        }

        }
}