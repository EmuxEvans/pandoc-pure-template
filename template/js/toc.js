(function($){
  $.fn.toc = function(options) {
    var headers = $('h1, h2, h3, h4, h5, h6').filter(function() {
      return this.id;
    }); 
    
    var output = $(this);
    if (!headers.length || headers.length < 3 || !output.length) {
      return;
    }
    
    var get_level = function(ele) { 
      return parseInt(ele.nodeName.replace("H", ""), 10); 
    }

    var get_open_tag = function(levels, this_level) { 
      var open_tag = '</li>';
      while(levels.length)
      {
        var history_level = levels[levels.length - 1];
        if (this_level <= history_level)
        {
          open_tag += '</ul></li>';
          levels.pop();
        }
        else
          break;
      }
      return open_tag
    }

    var level = get_level(headers[0]);
    var this_level;
    var levels = [];
    var first_head_id = headers[0].id;
    var tree = '<ul class="nav sidenav" data-spy="affix">';

    headers.each(function(_, header) {
      var open_tag = '';
      var active_header = '';
      var close_tag = '';
      var id = header.id;

      this_level = get_level(header);
      if (this_level == level && id == first_head_id)
        active_header = 'class="active"';
      if (this_level == level)
        open_tag = '</li>';
      else if(this_level < level)
        open_tag = get_open_tag(levels, this_level)
      else if(this_level > level)
      {
        open_tag = '<ul class =\"nav\">';
        levels.push(level)
      }
      
      var $header = $("#" + header.id);
      var $inner = $('a', $header);
      var title = $('a', $header).length > 0 ? $inner.html() : header.innerHTML;
      tree += open_tag + "<li " + active_header + "><a href='#" + id + "'>" + title + "</a>";

      level = this_level; // update for the next one
    });
    tree += "</li>";

    tree += "</ul>";
    output.html(tree);
  };
})(jQuery);
