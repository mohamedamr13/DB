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
    public partial class ViewAssignmentGrade : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ViewAssignGrade(object sender, EventArgs e)
        {
            try
            {

                String connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                int AssignmentNumber = Int16.Parse(AssignNum.Text);
                String AssignmentType = AssignType.Text;
                int CourseID = Int16.Parse(cid.Text);
                int stu_id = (int)Session["user"];



                SqlCommand ViewAssignGradeProc = new SqlCommand("viewAssignGrades", conn);
                ViewAssignGradeProc.CommandType = CommandType.StoredProcedure;

                ViewAssignGradeProc.Parameters.Add(new SqlParameter("@assignnumber", AssignmentNumber));
                ViewAssignGradeProc.Parameters.Add(new SqlParameter("@assignType", AssignmentType));
                ViewAssignGradeProc.Parameters.Add(new SqlParameter("@cid", CourseID));
                ViewAssignGradeProc.Parameters.Add(new SqlParameter("@sid", stu_id));

                SqlParameter grade = ViewAssignGradeProc.Parameters.Add("@assignGrade", SqlDbType.Int);
                grade.Direction = ParameterDirection.Output;

                SqlParameter error = ViewAssignGradeProc.Parameters.Add("@error", SqlDbType.VarChar, 50);
                error.Direction = ParameterDirection.Output;

                conn.Open();
                ViewAssignGradeProc.ExecuteNonQuery();
                conn.Close();

                string retError = ViewAssignGradeProc.Parameters["@error"].Value.ToString();
                int retGrade=0;
                try
                {
                    retGrade = (int)ViewAssignGradeProc.Parameters["@assignGrade"].Value;
                    //string value = retGrade.ToString();
                }

                catch
                {
                    retGrade = 0;
                }



                if (retError == "user does not take course")
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "You are not enrolled in this course" + "</p>";

                }

                else if (retGrade == 0)
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "Assignment grade not updated yet" + "</p>";
                }

                else
                {
                    err.Text = "";
                    grd.Text = "Your grade for this assignment is: " + retGrade.ToString();
                }
            }
            catch (ArgumentNullException)
            {
                grd.Text = "";
                err.Text = "<p style='color:red'>" + "Assignment grade not updated yet" + "</p>";
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Something went wrong, please press ok and check error message')", true);
                if (AssignType.Text == "" || AssignNum.Text == "" || cid.Text == "")
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "Please fill in all the required fields" + "</p>";

                }

                else if (AssignType.Text != "quiz" && AssignType.Text != "exam" && AssignType.Text != "project")
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "Please enter the correct assignment type" + "</p>";

                }

                else
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "This assignment does not exist" + "</p>";
                  }

            }






        }
    }
}