# frozen_string_literal: true

require 'roda'

class Router < Roda
  plugin :sessions, secret: Settings.secret_key
  plugin :route_csrf
  plugin :forme_set, secret: Settings.secret_key
  plugin :forme_route_csrf
  plugin :flash

  plugin :render, views: Settings.root.join('app/views')
  plugin :partials
  plugin :link_to
  plugin :path

  path :root, '/'
  path :about, '/about'
  path :contact, '/contact'
  path :legal_mentions, '/legal_mentions'

  path :articles, '/articles'
  path :new_article, '/articles/new'
  path(:edit_article) { |article| "/articles/#{article.id}/edit" }
  path(:delete_article) { |article| "/articles/#{article.id}/delete" }
  path(:show_article) { |article| "/articles/#{article.id}" }

  route do |r|
    r.root do
      view 'home'
    end

    r.on 'about' do
      r.get do
        view 'about'
      end
    end

    r.on 'contact' do
      r.get do
        view 'contact'
      end
    end

    r.on 'legal_mentions' do
      r.get do
        view 'legal_mentions'
      end
    end

    # GET /articles/*
    r.on 'articles' do
      # GET /articles
      r.get true do
        @articles = Article.all

        view 'articles/index'
      end

      # GET /articles/new
      r.get 'new' do
        @article = Article.new
        view 'articles/new'
      end

      # POST /articles
      r.post true do
        @article = Article.new
        forme_set(@article)
        @article.save

        flash[:notice] = 'Article créé avec succès'
        r.redirect articles_path
      end

      # GET /articles/{id}/*
      r.on Integer do |article_id|
        @article = Article.with_pk!(article_id)

        # DELETE /articles/{id}
        r.post 'delete' do
          @article.destroy

          flash[:error] = 'Article supprimé avec succès'
          r.redirect articles_path
        end

        # GET /articles/{id}
        r.get true do
          view 'articles/show'
        end

        # PATCH /articles/{id}
        r.get 'edit' do
          view 'articles/edit'
        end

        # POST /articles/{id}
        r.post do
          @article.set(r.params['article']) if r.params['article']

          if @article.save
            flash[:notice] = 'Article mis à jour avec succès'
            r.redirect articles_path
          else
            view 'articles/edit'
          end
        end
      end
    end
  end
end
