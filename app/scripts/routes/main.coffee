define [
  'backbone'
  '../views/story-items'
  '../views/add-story'
  '../views/edit-story'
  '../models/story'
  '../collections/story-items'
], ( Backbone, StoryCollectionView, AddStoryView, EditStoryView, StoryModel, StoryCollection ) ->
  class MainRouter extends Backbone.Router
    routes:
        "": "adminPage"
        "admin": "adminPage"
        "add-story": "addStory"
        "edit-story/:id": "editStory"

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
