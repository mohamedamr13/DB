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


            //  int id = Int16.Parse(username.Text);
            //string pass = password.Text;
            //  SqlCommand loginproc = new SqlCommand("userLogin", conn);
            // loginproc.CommandType = CommandType.StoredProcedure;
            //loginproc.Parameters.Add(new SqlParameter("@id", id));
            //loginproc.Parameters.Add(new SqlParameter("@password", pass));
            //SqlParameter success = loginproc.Parameters.Add("@success", SqlDbType.Int);
            //SqlParameter type = loginproc.Parameters.Add("@type", SqlDbType.Int);
            //conn.Open();
            //loginproc.ExecuteNonQuery();
            //conn.Close();
            try
            {

                String name = cName.Text;
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

                Response.Write(" New Course Added.. Awating Approval from Admin");
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

        }
}