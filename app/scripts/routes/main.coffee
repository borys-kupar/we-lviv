define [
  'backbone'
  '../views/story-items'
  '../views/add-story'
  '../views/edit-story'
  '../views/scanner'
  '../models/story'
  '../collections/story-items'
], ( Backbone, StoryCollectionView, AddStoryView, EditStoryView, ScannerView, StoryModel, StoryCollection ) ->
  class MainRouter extends Backbone.Router
    routes:
        "": "scanner"
        "admin": "adminPage"
        "admin/add-story": "addStory"
        "admin/edit-story/:id": "editStory"
        "scanner": "scanner"

    adminPage: ->
        storyCollection = new StoryCollection()

        $( "#content" ).html( new StoryCollectionView( model: storyCollection ).el )

        storyCollection.fetch( reset: true )

    addStory: ->
        addStoryView = new AddStoryView()

        $( "#content" ).html( addStoryView.render().el )

    editStory: ( id ) ->
        story = new StoryModel( id: id )

        $( "#content" ).html( new EditStoryView( model: story ).render().el )

        story.fetch( reset: true )

    scanner: ->
        $( "#content" ).html( new ScannerView().render().el )
