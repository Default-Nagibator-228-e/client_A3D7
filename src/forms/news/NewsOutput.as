package forms.news
{
   import alternativa.tanks.engine3d.ITextureMaterialRegistry;
   import forms.itemcategoriesview.ItemCategoriesView;
   import forms.itemscategory.ItemsCategoryView;
   import alternativa.tanks.models.battlefield.gui.statistics.field.CTFScoreIndicator;
   import alternativa.types.Long;
   import fl.containers.ScrollPane;
   import fl.controls.ScrollPolicy;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import forms.events.LoginFormEvent;
   import forms.shop.components.item.GridItemBase;
   
   public class NewsOutput extends Sprite
   {
      
	  public var cat:ItemCategoriesView;
	  
	  public var ct:Vector.<NewsOutputLine> = new Vector.<NewsOutputLine>();
	  
	  public var ct1:Vector.<OprosOutputLine> = new Vector.<OprosOutputLine>();
	  
	  public var ct2:Vector.<ItemsCategoryView> = new Vector.<ItemsCategoryView>();
	  
	  private var fge:Long = new Long(0, 5);
	  
	  public static var dr:Point = new Point(300, 80);
	  
	  public var al:AddLine;
      
      public function NewsOutput()
      {
		  super();
		  cat = new ItemCategoriesView();
		  addChild(this.cat);
		  if (Game.group == "admin")
		  {
			  var fdg:ItemsCategoryView = new ItemsCategoryView("", "", new Long(0, 1));
			  al = new AddLine();
			  fdg.addItem(al);
			  this.cat.addCategory(fdg);
		  }
		  setSize(dr.x,dr.y);
      }
	  
	  public function addOpLine(da:String,ou:String,out:String,b:String,j:String) : void
      {
		 var fdg:ItemsCategoryView = new ItemsCategoryView("", "", new Long(0, 1));
		 var s:OprosOutputLine = new OprosOutputLine(da, ou, out, b, this, j);
		 if (ct1.length > 0 && ct1[ct1.length-1].dat == da)
		 {
			 s.d.visible = false;
		 }
		 fdg.addItem(s);
		 this.cat.addCategory(fdg);
		 fdg.spdv = b;
		 ct2.push(fdg);
		 ct1.push(s);
		 //setSize(dr.x,dr.y);
      }
	  
	  public function golos(da:String) : void
      {
		 if (da != "" && da != null)
		 {
			 var parser:Object = JSON.parse(da);
			 var op:Array = parser.op;
			 for (var de2:int = 0; de2 < op.length; de2++)
			  {
				  for (var de1:int = 0; de1 < ct1.length; de1++)
				  {
					  if (ct1[de1].id == op[de2].id)
					  {
						  var dfes:int = op[de2].nom;
						  var ops:OprosOutputLine = ct1[de1];
						  ops.lin[dfes].golo();
						  for (var de3:int = 0; de3 < ops.lin.length; de3++)
						  {
								ops.lin[de3].vgolo();
								ops.lin[de3].removeEventListener(MouseEvent.CLICK,ops.sokol);
						  }
					  }
				  }
			  }
			 //setSize(dr.x, dr.y);
		 }
      }
	  
	  public function cop(da:String,ou:String,out:String,b:String,j:String) : void
      {
		 if (da != "" && da != null)
		 {
				  for (var de1:int = 0; de1 < ct1.length; de1++)
				  {
					  if (ct1[de1].id == b)
					  {
						  var s:OprosOutputLine = new OprosOutputLine(da,"","","",this,j);//da, ou, out, b, this, j);
						  if (ct1.length > 0 && ct1[ct1.length-1].dat == da)
						  {
							  s.d.visible = ct1[de1].d.visible;
						  }
						  for (var de3:int = 0; de3 < s.lin.length; de3++)
						  {
								ct1[de1].lin[de3].ch(s.lin[de3].na,s.lin[de3].si,s.lin[de3].ud,s.lin[de3].de);
						  }
						  setSize(dr.x,dr.y);
					  }
				  }
		 }
      }
	  
	  public function copg(b:String) : void
      {
		 if (b != "" && b != null)
		 {
				  for (var de1:int = 0; de1 < ct2.length; de1++)
				  {
					  if (ct2[de1].spdv == b)
					  {
						  this.cat.remCategory(ct2[de1]);
						  setSize(dr.x,dr.y);
					  }
				  }
		 }
      }
      
      public function addLine(da:String,ou:String,out:String,b:String) : void
      {
		 var fdg:ItemsCategoryView = new ItemsCategoryView("", "", new Long(0, 1));
		 var s:NewsOutputLine = new NewsOutputLine(da, ou, out, b, this);
		 if (ct.length > 0 && ct[ct.length-1].dat == da)
		 {
			 s.d.visible = false;
		 }
		 fdg.addItem(s);
		 this.cat.addCategory(fdg);
		 fdg.spdv = b;
		 ct2.push(fdg);
		 ct.push(s);
		 //setSize(dr.x,dr.y);
      }
      
      public function setSize(widh:Number, heigh:Number) : void
      {
		  dr.x = widh;
		  dr.y = heigh;
		  for (var de:int = 0; de < ct.length; de++)
		  {
			  ct[de].re(widh-55);
		  }
		  for (var de1:int = 0; de1 < ct1.length; de1++)
		  {
			  ct1[de1].re(widh-55);
		  }
		  if (this.cat != null)
		  {
			  this.cat.render(widh, heigh);
		  }
		  if (al != null)
		  {
			  al.re(this.cat.width-55);
		  }
      }
   }
}
