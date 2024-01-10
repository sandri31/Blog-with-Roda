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
    # Root route ("/"), renders the home view
    r.root { view 'home' }

    # Static pages
    ['about', 'contact', 'legal_mentions'].each do |page|
      r.is(page) { view page }
    end

    # Routes under "/articles"
    r.on 'articles' do
      r.on Integer do |article_id|
        # Fetches the article or returns 404 if not found
        @article = Article.with_pk!(article_id) or r.halt 404

        r.is 'delete' do
          # POST /articles/[article_id]/delete
          r.post do
            @article.destroy
            flash[:error] = 'Article supprimé avec succès'
            r.redirect articles_path
          end
        end

        r.get('edit') { view 'articles/edit' }
        r.get { view 'articles/show' }

        # POST /articles/[article_id]
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

      r.is do
        # GET /articles
        r.get do
          @articles = Article.all
          view 'articles/index'
        end

        # POST /articles
        r.post do
          @article = Article.new
          forme_set(@article)
          if @article.save
            flash[:notice] = 'Article créé avec succès'
            r.redirect articles_path
          else
            view 'articles/new'
          end
        end
      end

      # GET /articles/new
      r.get('new') do
        @article = Article.new
        view 'articles/new'
      end
    end
  end
end
