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
    public partial class Register : System.Web.UI.Page
    {
       

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void register(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            string firstName = fName.Text;
            string lastName = lName.Text;
            string pass = password.Text;
            string Email = email.Text;
            string Address = address.Text;
            string Gender = gender.SelectedValue;
            string Role = role.SelectedValue;
            int g = ReturnGender(Gender);
            int id = 0;
           
          
            SqlCommand StRegProc = new SqlCommand("studentRegister", conn);
            SqlCommand InsRegProc = new SqlCommand("instructorRegister", conn);
         
            StRegProc.CommandType = CommandType.StoredProcedure;
            InsRegProc.CommandType = CommandType.StoredProcedure;

             if (Role.Equals("Student")){
             StRegProc.Parameters.Add(new SqlParameter("@first_name", firstName));
             StRegProc.Parameters.Add(new SqlParameter("@last_name", lastName));
            StRegProc.Parameters.Add(new SqlParameter("@password", pass));
             StRegProc.Parameters.Add(new SqlParameter("@email", Email));
            StRegProc.Parameters.Add(new SqlParameter("@gender", g));
            StRegProc.Parameters.Add(new SqlParameter("@address", Address));




                conn.Open();

                StRegProc.ExecuteNonQuery();

                SqlCommand command = new SqlCommand("select top 1 id from Users ORDER BY id DESC ", conn);
                command.CommandType = CommandType.Text;
               
                SqlDataReader reader = command.ExecuteReader(CommandBehavior.CloseConnection);
                while (reader.Read())
                {
                    id = reader.GetInt32(reader.GetOrdinal("id"));
                }
                Session["user"] = id;
               // Response.Redirect("AddMobile.aspx");
              // we still didn't create a webpage where we redirect the user after registration


            }
            else
            {
               if (Role.Equals("Instructor"))
                {
                    InsRegProc.Parameters.Add(new SqlParameter("@first_name", firstName));
                    InsRegProc.Parameters.Add(new SqlParameter("@last_name", lastName));
                    InsRegProc.Parameters.Add(new SqlParameter("@password", pass));
                    InsRegProc.Parameters.Add(new SqlParameter("@email", Email));
                    InsRegProc.Parameters.Add(new SqlParameter("@gender", g));
                    InsRegProc.Parameters.Add(new SqlParameter("@address", Address));
                   
                    
                   
                    conn.Open();
                   InsRegProc.ExecuteNonQuery();

                    SqlCommand command = new SqlCommand("select top 1 id from Users ORDER BY id DESC ", conn);
                    command.CommandType = CommandType.Text;

                    SqlDataReader reader = command.ExecuteReader(CommandBehavior.CloseConnection);
                    while (reader.Read())
                    {
                        id = reader.GetInt32(reader.GetOrdinal("id"));
                    }
                    Session["user"] = id;
                  //  Response.Redirect("AddMobile.aspx");

                    // we still didn't create a webpage where we redirect the user after registration

                }
            }
        }

        protected int ReturnGender(string x)
        {
            if (x.Equals("Male"))
            {
                return 0;
            }
            else
            {
                return 1;
            }

        }

       
    }
}