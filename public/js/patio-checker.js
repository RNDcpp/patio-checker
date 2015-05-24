var $point = 0;
var $fill_timer = 0;
function fill_point()
{
	$bar_p=$('.result-bar').width()*100/$(".result-bar-container").width();
	if(($bar_p<$point-2))
	{
		$(".result-bar").width(($bar_p+1)+'%');
		$("span.point").text($bar_p);
	}else{
		$(".result-bar").width($point+'%');
		$("span.point").text($point);
		stop_fill();
	}
//	console.log($(".result-bar").width());
//	console.log($(".result-bar-container").width()*$point);
//	console.log($bar_p);
	console.log($point);
}
function set_fill(){
$fill_timer = window.setInterval(fill_point,10);
}
function stop_fill(){
window.clearInterval($fill_timer)
}
$(function($){
	$('#patio-form').submit(function(event){
		event.preventDefault();
		var $form = $(this);
		var $btn = $form.find('button');
		var $text = $form.find('textarea').attr('value');
		$.ajax({
			url: $form.attr('action'),
			type: $form.attr('method'),
			data: $form.serialize(),
			dataType:'json',
			tymeout:10000,
			beforeSend: function(xhr,settings){
				$btn.attr('disabled',true);
				$('#result-text').attr('hidden',false);
				$('#result-text').text('診断中．．．');
				$btn.text('解析中…')
			},
			complete: function(xhr,textStatus){
				$btn.attr('disabled',false);
				$btn.text('診断')
			},
			success: function(json){
				$point=json.point;
				$('#about').attr('hidden',true);
				$("#t_btn").html('<a href="https://twitter.com/share" class="twitter-share-button" data-text="「'+ $text + '」のぱちお度は'+$point+'%でした。" data-lang="ja">ツイート</a>')
				twttr.widgets.load();
				$('.result-bar').width(0);
				$('#result-text').text($text);
				$('#result-text').attr('hidden',false);
				$('#result-point').attr('hidden',false);
				set_fill();
				$form[0].reset;
			},
			error: function(xhr,textStatus,error){
				$('#about').attr('hidden',false);
				$("#t_btn").html('<a href="https://twitter.com/share" class="twitter-share-button" data-text="「'+ $text + '」のぱちお度は'+50.0+'%でした。" data-lang="ja">ツイート</a>')
				twttr.widgets.load();
				$('#result-point').attr('hidden',true);
				$('#result-text').attr('hidden',false);
				$('#result-text').text('取得に失敗しました．．．');
			}
		});
	});
});
