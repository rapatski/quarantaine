class EventSystem
{
  HashMap<String, Event> events;

  EventSystem() {
    events = new HashMap<String, Event>();
  }

  void add(int tNow, String _key, int _framesDuration, Color _col1, Color _col2)
  {
    events.put(_key, new Event(tNow, _key, _framesDuration, _col1, _col2));
    println("Created new \""+_key+"\" event at: "+tNow+" ["+_framesDuration+"]");
  }

  void add(int tNow, String _key, int _framesDuration, Color _col1)
  {
    Color _col2 = new Color(_col1);
    _col2.a = 0;
    add(tNow, _key, _framesDuration, _col1, _col2);
  }

  void update(int tNow)
  {
    
    Iterator it = events.entrySet().iterator();
    while (it.hasNext()) {
      HashMap.Entry entry = (HashMap.Entry)it.next();
      Event event = (Event) entry.getValue();

      if (!event.update(tNow)) {
        println("Removing \""+event.label+"\" event at: "+tNow+" ["+(tNow - event.tBirth)+"/"+event.tDuration+"]");
        it.remove(); // avoids a ConcurrentModificationException
      }
    }
    
    /*
    for (HashMap.Entry<String, Event> entry : events.entrySet())
     {
       Event event = entry.getValue();
       if (!event.update(tNow)) {
         println("Removing \""+event.label+"\" event at: "+tNow+" ["+(tNow - event.tBirth)+"/"+event.tDuration+"]");
         events.remove(entry.getKey());
       }
     }
     */

  }
}

class Event
{
  String label;

  int tBirth, tDeath;
  int tDuration;
  float t;

  Color startCol, endCol;

  EventAction action;

  Event(int tNow, String _label, int _framesDuration, Color _col1, Color _col2)
  {
    label = _label;

    tBirth = tNow;
    tDeath = tBirth + _framesDuration;
    tDuration = _framesDuration;

    startCol = new Color(_col1);
    endCol = new Color(_col2);
  }

  boolean update(int tNow)
  {
    t = (tNow - tBirth) / float(tDuration);

    if (tNow > tDeath)
      return false;

    return true;
  }

  color currentCol()
  {
    return startCol.mapTo(endCol, t, 0, 1);
  }
}

class EventAction
{

  EventAction() {
  };

  void update(float t)
  {
  }

  void draw(float t)
  {
  }
}

class ColorFlashAction extends EventAction
{
}
