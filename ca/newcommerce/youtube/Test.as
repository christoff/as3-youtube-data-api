/**
* ...
* @author Martin Legris ( http://blog.martinlegris.com )
* @version 0.1
*/

package ca.newcommerce.youtube
{
	import ca.newcommerce.youtube.data.AuthorData;	
	import ca.newcommerce.youtube.data.CategoryData;	
	import ca.newcommerce.youtube.data.GeneratorData;
	import ca.newcommerce.youtube.data.LinkData;
	import ca.newcommerce.youtube.data.MediaContentData;	
	import ca.newcommerce.youtube.data.MediaGroupData;
	import ca.newcommerce.youtube.data.RatingData;
	import ca.newcommerce.youtube.data.ThumbnailData;	
	import ca.newcommerce.youtube.data.VideoData;
	import ca.newcommerce.youtube.events.CommentFeedEvent;
	import ca.newcommerce.youtube.events.ContactFeedEvent;
	import ca.newcommerce.youtube.events.PlaylistFeedEvent;
	import ca.newcommerce.youtube.events.ProfileEvent;
	import ca.newcommerce.youtube.events.ResponseFeedEvent;
	import ca.newcommerce.youtube.events.StandardVideoFeedEvent;
	import ca.newcommerce.youtube.events.SubscriptionFeedEvent;
	import ca.newcommerce.youtube.events.VideoDataEvent;
	import ca.newcommerce.youtube.events.VideoFeedEvent;
	import ca.newcommerce.youtube.events.YouTubeEvent;
	import ca.newcommerce.youtube.webservice.YouTubeFeedClient;
	import ca.newcommerce.youtube.webservice.YouTubeDataClient;
	
	import ca.newcommerce.youtube.feeds.VideoFeed;
	import ca.newcommerce.youtube.iterators.LinkIterator;
	import ca.newcommerce.youtube.iterators.ThumbnailIterator;
	import ca.newcommerce.youtube.iterators.CategoryIterator;
	import ca.newcommerce.youtube.iterators.MediaContentIterator;
	import ca.newcommerce.youtube.iterators.AuthorIterator;
	
	import com.adobe.serialization.json.JSON;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;	
	import flash.events.NetStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;	

	public class Test extends MovieClip 
	{		
		protected var _wsFeed:YouTubeFeedClient;
		protected var _wsData:YouTubeDataClient;
		
		public function Test()
		{			
			_wsFeed = YouTubeFeedClient.getInstance();
			_wsData = YouTubeDataClient.getInstance();
			
			initEvents();
			
			startTest();
		}		
		
		protected function initEvents():void
		{
			// tiggered by getVideoComments(...)
			_wsFeed.addEventListener(CommentFeedEvent.COMMENT_DATA_RECEIVED, doCommentFeedReady);
			
			// triggered by getUserProfile(...)
			_wsFeed.addEventListener(ContactFeedEvent.USER_DATA_RECEIVED, doContactsReady);
			
			// triggered by getUserPlaylists(...)
			_wsFeed.addEventListener(PlaylistFeedEvent.PLAYLIST_DATA_RECEIVED, doPlaylistFeedReady);
			
			// triggered by getVideoResponses(...)
			_wsFeed.addEventListener(ResponseFeedEvent.RESPONSES_DATA_RECEIVED, doResponseFeedReady);
			
			// triggered by getStandardFeed
			_wsFeed.addEventListener(StandardVideoFeedEvent.STANDARD_VIDEO_DATA_RECEIVED, doStandardVideoFeedReady);
			
			// triggered by getRelatedVideos			
			_wsFeed.addEventListener(VideoFeedEvent.RELATED_VIDEOS_DATA_RECEIVED, doRelatedVideosReady);
			
			// triggered by getUserFavorites
			_wsFeed.addEventListener(VideoFeedEvent.USER_FAVORITES_DATA_RECEIVED, doFavoritesReady);
			
			// triggered by getUserPlaylists
			_wsFeed.addEventListener(VideoFeedEvent.VIDEO_PLAYLIST_DATA_RECEIVED, doPlaylistReady);
			
			// triggered by getVideos
			_wsFeed.addEventListener(VideoFeedEvent.VIDEO_DATA_RECEIVED, doVideosReady);
			
			// triggered by getUserProfile
			_wsFeed.addEventListener(ProfileEvent.PROFILE_DATA_RECEIVED, doProfileReady);
			
			// triggered by getUserSucscriptions
			_wsFeed.addEventListener(SubscriptionFeedEvent.SUBSCRIPTION_DATA_RECEIVED, doSubscriptionsReady);
			
			// triggered by getVideo
			_wsFeed.addEventListener(VideoDataEvent.VIDEO_INFO_RECEIVED, doVideoInfoReady);
			
			_wsData.addEventListener(YouTubeEvent.LOGIN_SUCCESSFULL, doLoggedIn);
			_wsData.addEventListener(YouTubeEvent.RATING_SUCCESSFULL, doRating);
			_wsData.addEventListener(YouTubeEvent.SEARCH_SUBSCRIPTION_SUCCESSFUL, doSearchSubscription);
			_wsData.addEventListener(YouTubeEvent.FAVORITES_SUBSCRIPTION_SUCCESSFUL, doFavoritesSubscription);
			_wsData.addEventListener(YouTubeEvent.CHANNEL_SUBSCRIPTION_SUCCESSFUL, doChannelSubscription);
			_wsData.addEventListener(YouTubeEvent.SUBSCRIPTION_DELETED, doSubscriptionDeleted);
		}
		
		protected function startTest():void
		{
			//_wsFeed.getUserProfile("rocketboom");
			//_wsFeed.getUserSubscriptions("mememolly");
			//_wsFeed.getVideoResponses("UwOA8H5Vaak");
			//_wsFeed.getUserContacts("mememolly");
			//_wsFeed.getUserSubscriptions("mememolly");
			//_wsFeed.getVideoComments("24Ryj1ywoqw");	
			//_wsFeed.getUserPlaylists("mememolly");
			//_wsFeed.getVideoComments("KDxLxIJ0oWI");
			//_wsFeed.getUserFavorites("mlegris");			
			//_wsFeed.getStandardFeed(YouTubeClient.STD_RECENTLY_FEATURED, YouTubeClient.TIME_WEEK, 1, 10);
			//_wsFeed.getStandardFeed(YouTubeClient.STD_TOP_RATED, YouTubeClient.TIME_MONTH, 1, 10);
			//_wsFeed.getStandardFeed(YouTubeClient.STD_MOST_DISCUSSED, YouTubeClient.TIME_TODAY);
			//_wsFeed.getStandardFeed(YouTubeClient.STD_MOST_RESPONSED, YouTubeClient.TIME_ALL);
			
			_wsFeed.getVideo("Y_b_-q2kyZU");
			
			// this call get you all videos that match "martial arts" query, and have the keywords "violent" and "boxing", but not the keyword "blood", ordered by viewCount, and include restricted material.
			//_wsFeed.getVideos("martial arts", "", null, null, ["violent", "boxing"], ["blood"], YouTubeClient.ORDER_BY_VIEWCOUNT, YouTubeClient.RACY_INCLUDE, 1, 10);
			
			//_wsData.login("username", "password");
		}
		
		protected function doSearchSubscription(evt:YouTubeEvent):void
		{
			var subscriptionId = evt.requestWrapper.subscriptionId;
			_wsData.deleteSubscription(subscriptionId);			
		}
		
		protected function doChannelSubscription(evt:YouTubeEvent):void
		{
			var subscriptionId = evt.requestWrapper.subscriptionId;
			_wsData.deleteSubscription(subscriptionId);
		}
		
		protected function doFavoritesSubscription(evt:YouTubeEvent):void
		{
			var subscriptionId = evt.requestWrapper.subscriptionId;
			_wsData.deleteSubscription(subscriptionId);
		}
		
		protected function doSubscriptionDeleted(evt:YouTubeEvent):void
		{
			trace("subscription:" + evt.requestWrapper.subscriptionId + " was deleted");
		}
		
		protected function doLoggedIn(evt:YouTubeEvent):void
		{
			//_wsData.rate("cOa1kHEiIpg", 5);
			//_wsData.favorite("66w7a1U1f-M");
			//_wsData.unfavorite("66w7a1U1f-M");
			
			//_wsData.subscribeChannel("jonlajoie");
			//_wsData.subscribeFavorites("jonlajoie");
			_wsData.comment("66w7a1U1f-M", "mmmmm");
			
			//_wsData.deleteSubscription("f841deb65d87511");
		}
		
		protected function doRating(evt:YouTubeEvent):void
		{
			trace("rating succesfull");
		}
		
		protected function doVideosReady(evt:VideoFeedEvent):void
		{
			DataTracer.traceVideos(evt.feed);
		}
		
		protected function doSubscriptionsReady(evt:SubscriptionFeedEvent):void
		{
			//DataTracer.traceSubscriptions(evt.feed);
			
			trace("subscription id:" + evt.feed.id);
			_wsData.deleteSubscription(evt.feed.id);
		}
		
		protected function doCommentFeedReady(evt:CommentFeedEvent):void
		{
			DataTracer.traceComments(evt.feed);
		}
		
		protected function doContactsReady(evt:ContactFeedEvent):void
		{
			DataTracer.traceContacts(evt.feed);
		}
		
		protected function doPlaylistFeedReady(evt:PlaylistFeedEvent):void
		{
			DataTracer.tracePlaylists(evt.feed);
		}
		
		protected function doResponseFeedReady(evt:ResponseFeedEvent):void
		{
			DataTracer.traceVideos(evt.feed);
		}
		
		protected function doStandardVideoFeedReady(evt:StandardVideoFeedEvent):void
		{
			DataTracer.traceVideos(evt.feed);
		}
		
		protected function doRelatedVideosReady(evt:VideoFeedEvent):void
		{
			DataTracer.traceVideos(evt.feed);
		}
		
		protected function doFavoritesReady(evt:VideoFeedEvent):void
		{
			DataTracer.traceVideos(evt.feed);
		}
		
		protected function doVideoFeedReady(evt:VideoFeedEvent):void
		{
			DataTracer.traceVideos(evt.feed);
		}
		
		protected function doPlaylistReady(evt:VideoFeedEvent):void
		{
			DataTracer.traceVideos(evt.feed);
		}
		
		protected function doProfileReady(evt:ProfileEvent):void
		{
			DataTracer.traceProfile(evt.profile);
		}	
		
		protected function doVideoInfoReady(evt:VideoDataEvent):void
		{
			DataTracer.traceVideo(evt.video);
		}
	}
}