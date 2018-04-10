import java.util.List;
import com.hp.opr.api.scripting.Event;

class Test_Script_Autosys{
  def init()
  {
  }

  def destroy()
  {
  }

  def process(List<Event> events)
  {
  events.each {
event -> modifyEvent(event)
}
  }
def modifyEvent(Event event)
{
String get_RelatedCiHint = event.getRelatedCiHint();
String get_title = event.getTitle();
String[] str_split;
str_split = get_title.split("is not started.");
event.setTitle(get_RelatedCiHint+":"+get_title.split("is not started.")[0]+"|||"+get_title.split("is not started.")[1]);
}
}