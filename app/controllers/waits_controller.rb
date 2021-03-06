class WaitsController < ApplicationController
  def index
		if params[:search]
			@wait = Wait.search(params[:search]).order("data_chiusura") #ricerco e ordino per stato
		else
			@wait = Wait.all.order("data_chiusura") #ordino i task per "data_chiusura")
		end
  end

  def edit
    @wait = Wait.find(params[:id])
  end

  def new
  end

  def create
    #render plain: params[:task].inspect
    @wait = Wait.new(params.require(:task).permit(:data_scadenza, :chi, :note))

    @wait.data_apertura = Date.today
    @wait.stato = 'ATTESA'
    
    @wait.save
    redirect_to waits_path
  end

  def update
    @wait = Wait.find(params[:id])

    if params[:wait][:stato] == 'FATTO' #prendo lo stato e vedo se è uguale a FATTO
      
      #creo un oggetto archived_task in cui mi salvo i parametri da salvare nella nuova tabella
      @archived_task = ArchivedTask.new(params.require(:wait).permit(:stato, :chi, :note))
      @archived_task.data_apertura = @wait.data_apertura
      @archived_task.data_chiusura = Date.today #salvo la data di chiusura della task da archiviara
      
      @archived_task.save

      @wait.destroy #elimino la task che sposto in archivio

      redirect_to archived_tasks_path

    elsif params[:wait][:stato] == 'IN LAVORAZIONE' || params[:wait][:stato] == 'DA FARE' 
      @task = Task.new(params.require(:wait).permit(:stato, :chi, :note))
      @task.data_apertura = @wait.data_apertura
      @task.save

      @wait.destroy #elimino la task che sposto in altra lista

      redirect_to tasks_path
    elsif params[:wait][:stato] == 'ATTESA'
      @wait.update(params.require(:wait).permit(:data_scadenza, :stato, :chi, :note))
      @wait.save

      redirect_to waits_path
    end
  end

  def destroy
    @wait = Wait.find(params[:id])
    @wait.destroy
   
    redirect_to waits_path
  end
end
