import java.io.Serializable;
import java.util.ArrayList;
import java.util.Vector;

public class Table implements Serializable {
    protected Vector<Page> pages;
    boolean noPages;
    String pk;
    String maxPageId;
    private static final long serialVersionUID = 6529685098267757690L;

	public Table() {
       pages = new Vector<Page>();
       noPages = true;
	}
	
	public void setNoPages(Boolean b)
	{
		this.noPages=b;

	}


	public String toString() {
		String s = "Primary key : " + pk + "\n" + "The table has no pages : " + noPages 
				+ "\n" + "Max Page ID : " + maxPageId + "\n";
		
		for( Page p : pages ) {
			s += " Page " +  p.id + " |" + "Min " + p.min + "|" + " Max " + p.max + " | Page Full  " + p.isFull;
			s+= "\n";
		}
		
		return s;
	}
	public static void main(String[] args) {
		Table t = new Table();
		Page p1 = new Page( 5,20,"1" );
		Page p2 = new Page( 30,40,"3" );
		Page p3 = new Page( 100,140,"2" );
		t.maxPageId = "3";
		t.pk = "ID";
		t.noPages = false;
		t.pages.add(p1);
		t.pages.add(p2);
		t.pages.add(p3);

		System.out.print( t.toString() );

	}
}
