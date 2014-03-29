define [
  'backbone'
  '../views/story-items'
  '../views/add-story'
  '../views/edit-story'
  '../views/scanner'
  '../views/admin-header'
  '../models/story'
  '../collections/story-items'
], ( Backbone, StoryCollectionView, AddStoryView, EditStoryView, ScannerView, AdminHeaderView, StoryModel, StoryCollection ) ->
  class MainRouter extends Backbone.Router
    routes:
        "": "scanner"
        "admin": "adminPage"
        "admin/add-story": "addStory"
        "admin/edit-story/:id": "editStory"
        "scanner": "scanner"

    adminPage: ->
        storyCollection = new StoryCollection()

        $( ".header-placement" ).html( new AdminHeaderView().render().el )
        $( "#content" ).html( new StoryCollectionView( model: storyCollection ).el )

        storyCollection.fetch( reset: true )

    addStory: ->
        addStoryView = new AddStoryView()

        $( ".header-placement" ).html( new AdminHeaderView().render().el )
        $( "#content" ).html( addStoryView.render().el )

    editStory: ( id ) ->
        story = new StoryModel( _id: id )

        $( ".header-placement" ).html( new AdminHeaderView().render().el )
        $( "#content" ).html( new EditStoryView( model: story ).el )

        story.fetch()

    scanner: ->
        $( ".header-placement" ).empty()
        $( "#content" ).html( new ScannerView().render().el )
