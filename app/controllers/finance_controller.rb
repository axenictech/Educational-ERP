# This controller manages the all financial operation of the colleges
# or school like manage admission fees, manage collection of admission
# fees, fees structure, fees defaulters, transaction, payslip, asset
# and liability management
class FinanceController < ApplicationController
  # Display all transaction category list
  def transaction_category
    @transaction_categories ||= FinanceTransactionCategory.all
    authorize! :read, @transaction_categories.last
  end

  # Create new object of finance transaction category for save the
  # record in database.
  def new_transaction_category
    @transaction_category = FinanceTransactionCategory.new
    authorize! :create, @transaction_category
  end

  # Create transaction category object with user input value throw
  # new method.
  # Save the transaction category record in database.
  def create_transaction_category
    @transaction_category = FinanceTransactionCategory.new\
    (transaction_category_params)
    @transaction_category.save
    flash[:notice] = t('transaction_category_create')
    @transaction_categories ||= FinanceTransactionCategory.all
  end

  # Retrieve user inputed record from transaction category for update.
  def edit_transaction_category
    @transaction_category = FinanceTransactionCategory.shod(params[:id])
    authorize! :update, @transaction_category
  end

  # Find out the user inputed record in database with shod method.
  # Update transaction record to the database.
  def update_transaction_category
    @transaction_category = FinanceTransactionCategory.shod(params[:id])
    @transaction_category.update(transaction_category_params)
    flash[:notice] = t('transaction_category_update')
    @transaction_categories ||= FinanceTransactionCategory.all
  end

  # Fetch the user inputed transaction category record.
  # Delete from database with destroy method.
  def delete_transaction_category
    @transaction_category = FinanceTransactionCategory.shod(params[:id])
    authorize! :delete, @transaction_category
    @transaction_category.destroy
    flash[:notice] = t('transaction_category_delete')
    redirect_to transaction_category_finance_index_path
  end

  # Create the fresh object of donation for storing new value.
  def donation
    @donation = FinanceDonation.new
    authorize! :create, @donation
  end

  # Insert the new donation record in database
  def create_donation
    @donation = FinanceDonation.new(donation_params)
    if @donation.save
      @donation.create_transaction
      flash[:notice] = t('donation_create')
      redirect_to donation_receipt_finance_path(@donation)
    else
      render 'donation'
    end
  end

  # Generating the information for displaying donation receipt.
  def donation_receipt
    @donation = FinanceDonation.shod(params[:id])
    authorize! :read, @donation
  end

  # Display pdf of donation receipt for specific donor.
  def finance_donation_receipt
    @donation = FinanceDonation.shod(params[:id])
    @general_setting = GeneralSetting.first
    render 'finance_donation_receipt', layout: false
  end

  # Display all donors list.
  def donors
    @donors ||= FinanceDonation.all
    authorize! :read, @donors.first
  end

  # Getting the already existed donation for update.
  def edit_donation
    @donation = FinanceDonation.shod(params[:id])
    authorize! :update, @donation
  end

  # Actual updation of donation record.
  def update_donation
    @donation = FinanceDonation.shod(params[:id])
    if @donation.update(donation_params)
      @donation.update_transaction
      flash[:notice] = t('donation_update')
      redirect_to donors_finance_index_path
    else
      render 'edit_donation'
    end
  end

  # Delete the particular donation.
  def delete_donation
    @donation = FinanceDonation.shod(params[:id])
    authorize! :delete, @donation
    @donation.destroy
    flash[:notice] = t('donation_delete')
    redirect_to donation_finance_index_path
  end

  # Create the fresh object for inserting the asset record in database.
  def new_asset
    @asset = Asset.new
    authorize! :create, @asset
  end

  # Insert the asset details in database.
  def create_asset
    @assets ||= Asset.all
    @asset = Asset.new(asset_params)
    @asset.save
    flash[:notice] = t('asset_create')
  end

  # Display all asset list.
  def view_asset
    @assets ||= Asset.all
    authorize! :read, @assets.first
  end

  # Creating the object for update the asset details which are
  # already existed in database.
  def edit_asset
    @asset = Asset.shod(params[:id])
    authorize! :update, @asset
  end

  # Update the given asset details in database.
  def update_asset
    @asset = Asset.shod(params[:id])
    @asset.update(asset_params)
    @assets ||= Asset.all
    flash[:notice] = t('asset_update')
  end

  # Delete the given asset details from database.
  def delete_asset
    @asset = Asset.shod(params[:id])
    authorize! :delete, @asset
    @asset.destroy
    flash[:notice] = t('asset_delete')
    redirect_to view_asset_finance_index_path
  end

  # Collecting the information for display asset list pdf
  def asset_list
    @assets ||= Asset.all
    @general_setting = GeneralSetting.first
    render 'asset_list', layout: false
  end

  # Display each asset particularly.
  def each_asset_view
    @asset = Asset.shod(params[:id])
    authorize! :read, @asset
  end

  # Create the fresh object for inserting the liability record in
  # database.
  def new_liability
    @liability = Liability.new
    authorize! :read, @liability
  end

  # Insert the liability details in database.
  def create_liability
    @liability = Liability.new(liability_params)
    @liability.save
    flash[:notice] = t('liability_create')
  end

  # Display all liability list.
  def view_liability
    @liabilities ||= Liability.all
    authorize! :read, @liabilities.first
  end

  # Creating the object for update the liability details which are
  # already existed in database.
  def edit_liability
    @liability = Liability.shod(params[:id])
    authorize! :update, @liability
  end

  # Update the given liability details in database.
  def update_liability
    @liabilities ||= Liability.all
    @liability = Liability.shod(params[:id])
    @liability.update(liability_params)
    flash[:notice] = t('liability_update')
  end

  # Delete the given liability details from database.
  def delete_liability
    @liability = Liability.shod(params[:id])
    authorize! :delete, @liability
    @liability.destroy
    flash[:notice] = t('liability_delete')
    redirect_to view_liability_finance_index_path
  end

  # Display each liability particularly.
  def each_liability_view
    @liability = Liability.shod(params[:id])
    authorize! :read, @liability
  end

  # Collecting the information for display liability list pdf
  def liability_list
    @liabilities ||= Liability.all
    @general_setting = GeneralSetting.first
    render 'liability_list', layout: false
  end

  # Fetching the automatic transaction details from database and
  # display list.
  def automatic_transaction
    @automatic_transactions ||= FinanceTransactionTrigger.all
    authorize! :read, @automatic_transactions.first
  end

  # Create the fresh object for inserting the automatic transaction
  # record in database for the given categories.
  def new_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.new
    @categories ||= FinanceTransactionCategory.all
    authorize! :create, @automatic_transaction
  end

  # Insert the automatic transaction details in database.
  def create_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.new\
    (auto_transaction_params)
    @automatic_transaction.save
    flash[:notice] = t('automatic_transaction_create')
    @automatic_transactions ||= FinanceTransactionTrigger.all
  end

  # Creating the object for update the automatic transaction
  # details which are already existed in database.
  def edit_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.shod(params[:id])
    @categories ||= FinanceTransactionCategory.all
    authorize! :update, @automatic_transaction
  end

  # Update the given automatic transaction details in database.
  def update_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.shod(params[:id])
    @automatic_transaction.update(auto_transaction_params)
    flash[:notice] = t('automatic_transaction_update')
    @automatic_transactions ||= FinanceTransactionTrigger.all
  end

  # Find the record from finance transaction trigger with the help
  # of params id and delete this record. Display the notice message.
  # Perform authorization.
  def delete_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.shod(params[:id])
    authorize! :delete, @automatic_transaction
    @automatic_transaction.destroy
    flash[:notice] = t('automatic_transaction_delete')
    redirect_to automatic_transaction_finance_index_path
  end

  # Create the fresh object to save the record of expenses.
  def new_expense
    @transaction = FinanceTransaction.new
    @categories ||= FinanceTransactionCategory.expense
    authorize! :create, @transaction
  end

  # Insert the record of expenses.
  def create_expense
    @transaction = FinanceTransaction.new(transaction_params)
    if @transaction.save
      flash[:notice] = t('expense_create')
      redirect_to new_expense_finance_index_path
    else
      @categories ||= FinanceTransactionCategory.expense
      render 'new_expense'
    end
  end

  # This action display the list of expenses of given start and
  # end date.
  def expense_list
    @start_date = params[:expense][:start_date].to_date
    @end_date = params[:expense][:end_date].to_date
    if @end_date.nil? || @start_date.nil?
      flash[:alert] = t('expense_error')
      render 'view_expense'
    else
      @expenses ||= FinanceTransaction.list(@start_date, @end_date)
    end
    authorize! :read, @expenses.first unless @expenses.nil?
  end

  # This action provide the object of given expense record for update.
  def edit_expense
    @transaction = FinanceTransaction.shod(params[:id])
    @categories ||= FinanceTransactionCategory.expense
    authorize! :update, @transaction
  end

  # Actual updation of expense is done here.
  def update_expense
    @transaction = FinanceTransaction.shod(params[:id])
    if @transaction.update(transaction_params)
      flash[:notice] = t('expense_update')
      redirect_to view_expense_finance_index_path
    else
      @categories ||= FinanceTransactionCategory.expense
      render 'edit_expense'
    end
  end

  # This action perform a process of delete the expense record.
  def delete_expense
    @transaction = FinanceTransaction.shod(params[:id])
    authorize! :delete, @transaction
    @transaction.destroy
    flash[:notice] = t('expense_delete')
    redirect_to view_expense_finance_index_path
  end

  # Generate the object for displaying expense report pdf.
  def finance_expense_report
    @general_setting = GeneralSetting.first
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @expenses ||= FinanceTransaction.list(@start_date, @end_date)
    render 'finance_expense_report', layout: false
  end

  # Create the fresh object to save the record of income.
  def new_income
    @transaction = FinanceTransaction.new
    @categories ||= FinanceTransactionCategory.income
    authorize! :create, @transaction
  end

  # Insert the record of income.
  def create_income
    @transaction = FinanceTransaction.new(transaction_params)
    if @transaction.save
      flash[:notice] = t('income_create')
      redirect_to new_income_finance_index_path
    else
      @categories ||= FinanceTransactionCategory.income
      render 'new_income'
    end
  end

  # This action display the list of income of given start and
  # end date.
  def income_list
    @start_date = params[:income][:start_date].to_date
    @end_date = params[:income][:end_date].to_date
    if @start_date.nil? || @end_date.nil?
      flash[:alert] = t('income_error')
      render 'view_income'
    else
      @incomes ||= FinanceTransaction.list(@start_date, @end_date)
    end
    authorize! :read, @incomes.first unless @incomes.nil?
  end

  # This action provide the object of given income record for update.
  def edit_income
    @transaction = FinanceTransaction.shod(params[:id])
    @categories ||= FinanceTransactionCategory.income
    authorize! :create, @transaction
  end

  # Actual updation of income is done here.
  def update_income
    @transaction = FinanceTransaction.shod(params[:id])
    if @transaction.update(transaction_params)
      flash[:notice] = t('income_update')
      redirect_to view_income_finance_index_path
    else
      @categories ||= FinanceTransactionCategory.income
      render 'edit_income'
    end
  end

  # This action perform a process of delete the income record.
  def delete_income
    @transaction = FinanceTransaction.shod(params[:id])
    authorize! :delete, @transaction
    @transaction.destroy
    flash[:notice] = t('income_delete')
    redirect_to view_income_finance_index_path
  end

  # Generate the object for displaying income report pdf
  def finance_income_report
    @general_setting = GeneralSetting.first
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @incomes ||= FinanceTransaction.list(@start_date, @end_date)
    render 'finance_income_report', layout: false
  end

  # Display transaction list for given start date and end date.
  def transactions_list
    @start_date = params[:transaction][:start_date].to_date
    @end_date = params[:transaction][:end_date].to_date
    if @start_date.nil? || @end_date.nil?
      flash[:alert] = t('transaction_error')
      render 'transaction_report'
    else
      @categories ||= FinanceTransactionCategory.all
    end
    authorize! :read, @categories.first unless @categories.nil?
  end

  # Display the expense details for given start and end date.
  def expense_details
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @category = FinanceTransactionCategory.shod(params[:category])
    @expenses ||= @category.finance_transactions.list(@start_date, @end_date)
    render 'expense_list'
    authorize! :read, @category
  end

  # Display the income details for given start and end date.
  def income_details
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @category = FinanceTransactionCategory.shod(params[:category])
    @incomes ||= @category.finance_transactions.list(@start_date, @end_date)
    render 'income_list'
    authorize! :read, @category
  end

  # Generate the object for displaying transaction report pdf.
  def finance_transaction_report
    @general_setting = GeneralSetting.first
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @categories ||= FinanceTransactionCategory.all
    render 'finance_transaction_report', layout: false
  end

  # This action perform a operation of compare the transaction
  # within one start and end date to other start and end date.
  def transactions_comparison
    @start_date1 = params[:transaction][:start_date1].to_date
    @end_date1 = params[:transaction][:end_date1].to_date
    @start_date2 = params[:transaction][:start_date2].to_date
    @end_date2 = params[:transaction][:end_date2].to_date
    if @start_date1.nil? || @start_date2.nil? \
      || @end_date1.nil? || @end_date2.nil?
      render 'compare_report', alert: t('transaction_error')
    else
      @categories ||= FinanceTransactionCategory.all
    end
  end

  # create the new object of category for specific batches
  def new_master_category
    @master_category = FinanceFeeCategory.new
    @batches ||= Batch.all
    authorize! :create, @master_category
  end

  # Fetch all batches in batches object.
  def assign_batch
    @batches ||= Batch.all
  end

  # Fetch all batches in batches object.
  def remove_batch
    @batches ||= Batch.all
  end

  # Insert the record for master category
  def create_master_category
    @master_category = FinanceFeeCategory.new(fee_category_params)
    @master_category.save
    @master_category.fee_category(params[:batches])
    flash[:notice] = t('fee_category_create')
  end

  # Fetch the batch throw drop down list.
  # Show fees list for selected batch.
  def fees_list
    @batch = Batch.shod(params[:batch][:id])
    @master_categories ||= @batch.finance_fee_categories
    authorize! :read, @master_categories.first
  end

  # Fetch the fee category record which you have to update.
  # Display the batch which is adjacent to given fee category.
  def edit_master_category
    @batch = Batch.shod(params[:id])
    @master_category = FinanceFeeCategory.shod(params[:format])
    authorize! :update, @master_category
  end

  # @batch object store the user inputed batch from database.
  # Using @batch object fetch the master category record.
  # Update the master category record with update method and
  # send a flash message.
  def update_master_category
    @batch = Batch.shod(params[:id])
    @master_category = @batch.finance_fee_categories.shod(params[:id])
    @master_category.update(fee_category_params)
    flash[:notice] = t('fee_category_update')
    @master_categories ||= @batch.finance_fee_categories
  end

  # @batch object store the user inputed batch from database.
  # Using @batch object fetch the master category record.
  # delete the master category record with destroy method and
  # send a flash message.
  def delete_master_category
    @batch = Batch.shod(params[:batch_id])
    @master_category = @batch.finance_fee_categories.shod(params[:id])
    authorize! :delete, @master_category
    @master_category.destroy
    flash[:notice] = t('fee_category_delete')
    @master_categories ||= @batch.finance_fee_categories
  end

  # Create a particular for specific finance fee category.
  def new_fees_particular
    @fee = FinanceFeeParticular.new
    @categories ||= FinanceFeeCategory.all
    authorize! :create, @fee
  end

  # Generate the drop down list for finance fee category
  # which is foreign key for save the particular in database.
  def category_batch
    @master_category = FinanceFeeCategory.shod(params[:id])
    @batches ||= @master_category.batches
    authorize! :read, @master_category
  end

  # Insert the record of particular fee for specific finance category.
  def create_fees_particular
    @categories ||= FinanceFeeCategory.all
    @fee = FinanceFeeParticular.new(fee_particular_params)
    result = FinanceFeeParticular.create_fee(fee_particular_params\
      , params[:batches], params[:mode]\
      , params[:admission_no], params[:category])
    if result == 1
      render 'new_fees_particular'
    else
      flash[:notice] = t('fee_create')
      redirect_to master_fees_finance_index_path
    end
  end

  # Displaying the particular of specific fees of particular batch
  def master_category_particular
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @particular_fees ||= @master_category.particulars(@batch.id)
    authorize! :read, @master_category
  end

  # Display all batches for creating and viewing particular of fess.
  def master_fees
    @batches ||= Batch.includes(:course).all
  end

  # creating fresh object for particular
  def new_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @fee = FinanceFeeParticular.new
    authorize! :create, @fee
  end

  # def student_admission_no
  #   @master_category = FinanceFeeCategory.shod(params[:id])
  #   @fee = FinanceFeeParticular.new
  #   authorize! :read, @fee
  # end

  # def student_category
  #   @master_category = FinanceFeeCategory.shod(params[:id])
  #   @fee = FinanceFeeParticular.new
  #   authorize! :read, @fee
  # end

  # This action save the record of particulars for specific finance fee category.
  # Batch id and fee categoy is the foreign key for particular record.
  # Particular is assign by three role i.e.Admission number,student category
  # and common to all. For that operation @fee.set is used.
  def create_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @particular_fees ||= @master_category.particulars(@batch.id)
    @fee = @master_category.finance_fee_particulars.new(fee_particular_params)
    @fee.set(params[:mode], params[:admission_no]\
      , params[:category], @batch.id)
    @fee.save
    flash[:notice] = t('fee_create')
  end

  # Fetch the finance particular record for update from database.
  def edit_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @fee = @master_category.finance_fee_particulars.shod(params[:id])
    authorize! :update, @fee
  end

  # This action is perform a operation for update the particular.
  # For that it require a batch record.
  # After finding the batch, we find out finance fee category.
  # With the help of finance fee category update the particulars record.
  def update_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @particular_fees ||= @master_category.particulars(@batch.id)
    @fee = @master_category.finance_fee_particulars.shod(params[:id])
    @fee.update(fee_particular_params)
    flash[:notice] = t('fee_update')
  end

  # This action is perform a operation for delete the particulars.
  # For that it require a batch record.
  # After finding the batch record, we find out finance fee category.
  # With the help of finance fee category delete the particulars record.
  def delete_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @fee = @master_category.finance_fee_particulars.shod(params[:fee])
    authorize! :delete, @fee
    @particular_fees ||= @master_category.particulars(@batch.id)
    @fee.destroy
    flash[:notice] = t('fee_delete')
  end

  # Create the object for save discount record on the basis of category.
  def new_fee_discount
    @fee_discount = FeeDiscount.new
    @categories ||= FinanceFeeCategory.all
    authorize! :create, @discount
  end

  # Assign discount type for type object.
  def discount_type
    @type = params[:type]
  end

  # Create the discount record for specific finance category.
  def create_fee_discount
    @categories ||= FinanceFeeCategory.all
    @discount = FeeDiscount.new(fee_discount_params)
    result = FeeDiscount.create_discount(fee_discount_params\
      , params[:batches], params[:admission_no], params[:category])
    if result == 1
      render 'new_fee_discount'
    else
      flash[:notice] = t('discount_create')
      redirect_to new_fee_discount_finance_index_path
    end
  end

  # This action provide fee categories for drop down list for view the discount
  # For that we require batch id. getting the @batch object we can find out
  # categories for that specific batch.
  def fee_category
    @batch = Batch.shod(params[:id])
    @categories ||= @batch.finance_fee_categories
    authorize! :read, @categories.first
  end

  # This action provide discount list for selected fee category.
  # For that we require batch id and finance fee category.
  # getting the @batch object and @master_category object we can find out
  # discounts for that specific batch.
  def discount_view
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @discounts ||= @master_category.discounts(@batch.id)
    authorize! :read, @discounts.first
  end

  # This action retrieve one discount record, which we have update.
  # For fetch this specific discount record, out requirment is batch id,
  # master id and discount id.
  def edit_fee_discount
    @batch = Batch.shod(params[:id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @discount = @master_category.fee_discounts.shod(params[:discount_id])
    authorize! :update, @discount
  end

  # To find out discount record for update, we want a fee category id
  # and batch id for that we create a @batch, @master_category object.
  # For update discount update method is used.
  def update_fee_discount
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @discount = @master_category.fee_discounts.shod(params[:id])
    @discount.update(fee_discount_params)
    flash[:notice] = t('discount_update')
    @discounts ||= @master_category.discounts(@batch.id)
  end

  # To find out discount record for delete, we want a fee category id
  # and batch id, for that we create a @batch, @master_category object.
  # For delete discount record destroy method is used.
  def delete_fee_discount
    @batch = Batch.shod(params[:id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @discount = @master_category.fee_discounts.shod(params[:discount_id])
    authorize! :delete, @discount
    @discount.destroy
    flash[:notice] = t('discount_delete')
    @discounts ||= @master_category.discounts(@batch.id)
  end

  # Create the object for insert the collection record on the basis
  # of finance category.
  def new_fee_collection
    @collection = FinanceFeeCollection.new
    @categories ||= FinanceFeeCategory.all
    authorize! :create, @collection
  end

  # Insert the collection record with the foriegh key finance
  # fee category.
  def create_fee_collection
    @collection = FinanceFeeCollection.new(collection_params)
    result = FinanceFeeCollection.fee(collection_params, params[:batches])
    if result == true
      @categories ||= FinanceFeeCategory.all
      render 'new_fee_collection'
    else
      flash[:notice] = t('collection_create')
      redirect_to new_fee_collection_finance_index_path
    end
  end

  # This action display the fee collection of specific batch.
  # For that we first find out the batch throw shod method.
  # and then fetch the collection list according to @batch object.
  def view_fee_collection
    @batch = Batch.shod(params[:id])
    @collections ||= @batch.finance_fee_collections
    authorize! :read, @collections.first
  end

  # This action provide a fee collection record for edit.
  # For that we first find out the batch because the collection is created
  # for specific batch. Then fee collection record is find out for update.
  def edit_fee_collection
    @batch = Batch.shod(params[:id])
    @collections ||= @batch.finance_fee_collections
    @collection = @batch.finance_fee_collections.shod(params[:collection_id])
    authorize! :update, @collection
  end

  # This action update the collection record. Find out batch with the help
  # of shod method. Find out the collection for specific batch with the help
  # of @batch object and update the record by update method.
  def update_fee_collection
    @batch = Batch.shod(params[:batch_id])
    @collections ||= @batch.finance_fee_collections
    @collection = @batch.finance_fee_collections.shod(params[:id])
    @collection.update(collection_params)
    flash[:notice] = t('collection_update')
  end

  # To find out fee collection record for delete, we want a fee collection id
  # and batch id, for that we create a @batch, @collection object.
  # For delete collection record destroy method is used.
  def delete_fee_collection
    @batch = Batch.shod(params[:id])
    @collection = @batch.finance_fee_collections.shod(params[:collection_id])
    authorize! :delete, @collection
    @collections ||= @batch.finance_fee_collections
    @collection.destroy
    flash[:notice] = t('collection_delete')
  end

  # Display the particulars and discounts for particular finance
  # fee collection.
  def collection_details_view
    @collection = FinanceFeeCollection.shod(params[:id])
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    authorize! :read, @collection
  end

  # Displaying fee collection reciept of students accorging to batch.
  def fees_submission_batch
    @batches ||= Batch.includes(:course).all
    @collections ||= Batch.first.finance_fee_collections unless Batch.first.nil?
    authorize! :read, @collections.first unless @collections.nil?
  end

  # This action helpful to generate the data for collection list.
  # We get the collection when appropriat batch is selected.
  # for that we use a shod method on Batch and with help of @batch
  # object we get required collection date.
  def fee_collection_date
    @batch = Batch.shod(params[:id])
    @collections ||= @batch.finance_fee_collections
    authorize! :read, @collections.first
  end

  # This action useful to display the student collection reciept.
  # When collection date is selected then this action is processed.
  # It create the various object throw the fee collection id.
  # It calls the another action 'student_fees2'
  def student_fees
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @student = @finance_fees.first.student
    @previous = @collection.previous(@student)
    @next = @collection.next(@student)
    @fee = @collection.fee(@student)
    student_fee2
    authorize! :read, @collection
  end

  # It is the subpart of action 'student_fees'
  # It fetch the particulars, discounts and transaction record.
  def student_fee2
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
  end

  # This action collect object for displaying the student fees details.
  def student_fees_details
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @finance_fee = @finance_fees.shod(params[:finance_fee_id])
    @student = @finance_fee.student
    @previous = @collection.previous(@student)
    student_fees_details2
    authorize! :read, @collection
  end

  # It is the subpart of action 'student_fees_details;
  # It fetch the particulars records, discount records and transaction records.
  def student_fees_details2
    @next = @collection.next(@student)
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
  end

  # Add fine for particular student.
  def pay_fine
    @student_fine = FinanceFee.shod(params[:finance_fee_id])
    @student_fine.create_fine(params[:fine])
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @finance_fee = @finance_fees.shod(params[:finance_fee_id])
    @student = @finance_fee.student
    pay_fine2
    authorize! :read, @collection
  end

  # It is a sub part of the action 'def pay_fine'
  # This is helpful to add fine for student.
  def pay_fine2
    @previous = @collection.previous(@student)
    @next = @collection.next(@student)
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
  end

  # Insert the payment details of students.
  def pay_fee
    @student_fee = FinanceFee.shod(params[:finance_fee_id])
    @student_fee.create_transaction(params[:amount], false)
    @student_fee.update(is_paid: true) if params[:amount] \
    == params[:pay_amount]
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @finance_fee = @finance_fees.shod(params[:finance_fee_id])
    pay_fee2
    authorize! :read, @collection
  end

  # Its a subpart of the action 'def pay_fee' and helpful to
  # insert payment details of students.
  def pay_fee2
    @student = @finance_fee.student
    @previous = @collection.previous(@student)
    @next = @collection.next(@student)
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
  end

  # Creating object with data for display record on pdf.
  def student_fee_receipt
    @general_setting = GeneralSetting.first
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @finance_fee = @finance_fees.shod(params[:finance_fee_id])
    student_fee_receipt2
    render 'student_fee_receipt', layout: false
  end

  # Its a subpart of the action 'def student_fee_receipt'
  def student_fee_receipt2
    @student = @finance_fee.student
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @fines ||= @fee.finance_fines
  end

  # This action perform search operaion on the student.
  def search_student
    @students = Student.search(params[:search], 'present')
  end

  # Display all collection which is applied to specific student.
  def fees_collection_student
    @student = Student.shod(params[:id])
    @collections ||= @student.finance_fee_collections
    authorize! :read, @collections.first
  end

  # This action is collect the object for display fee reciept for specific student.
  # For that we required a student id and fee collection id.
  # With the help of student and collection id we can fetch the category,
  # finance fees, fee, particulars, disocunts,transaction and fines.
  def student_fees_submission
    @student = Student.shod(params[:student_id])
    @collection = FinanceFeeCollection.shod(params[:collection_id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
    authorize! :read, @collection
  end

  # Search student for fees structure.
  def student_search
    @students = Student.search(params[:search], 'present')
  end

  # Create drop down list of collection of particular student id.
  def fee_collection_structure
    @student = Student.shod(params[:id])
    @collections ||= @student.finance_fee_collections
    authorize! :read, @collections.first
  end

  # This action generate the object to provide details for view fee structure
  # for selected student. It display the particular, discount, fines in well
  # format with total payment amount.
  def student_fees_structure
    @student = Student.shod(params[:student_id])
    @collection = FinanceFeeCollection.shod(params[:collection_id])
    @category = @collection.finance_fee_category
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    authorize! :read, @collection
  end

  # This action provide the necessary object with information to display pdf
  # for fee structure.
  def fee_structure
    @general_setting = GeneralSetting.first
    @student = Student.shod(params[:student_id])
    @collection = FinanceFeeCollection.shod(params[:collection_id])
    @category = @collection.finance_fee_category
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    render 'fee_structure', layout: false
  end

  # Create the dropdown list for courses,batches and collections.
  def fees_defaulters
    @courses ||= Course.all
    @batches ||= Course.first.batches unless Course.first.nil?
    @collections ||= Batch.first.finance_fee_collections unless Batch.first.nil?
    authorize! :read, @collections.first unless @collections.nil?
  end

  # Collect batches of specific course.
  def batch_choice
    @course = Course.shod(params[:id])
    @batches ||= @course.batches
  end

  # Collect collections of specific batch.
  def collection_choice
    @batch = Batch.shod(params[:id])
    @collections ||= @batch.finance_fee_collections
    authorize! :read, @collections.first
  end

  # Display defaulter student list of specific finance collection.
  def defaulter_students
    @collection = FinanceFeeCollection.shod(params[:id])
    @students = @collection.students.uniq
    authorize! :read, @collection
  end

  # Collect the object for display defaulter student list pdf.
  def fees_defaulters_list
    @general_setting = GeneralSetting.first
    @collection = FinanceFeeCollection.find(params[:id])
    @students = @collection.students.uniq
    render 'fees_defaulters_list', layout: false
  end

  # Create finance fees record when student make payment.
  def pay_fees_defaulters
    @student = Student.shod(params[:student_id])
    @collection = FinanceFeeCollection.shod(params[:collection_id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
    authorize! :read, @collection
  end

  # create the drop down list for select salary month.
  # so that only salary date field is fetch from monthly payslip.
  def approve_monthly_payslip
    @salary_months ||= MonthlyPayslip.select(:salary_date).distinct
  end

  # This action useful to provide salary details for approve.
  # We want to take date so it is done throw params[:date].
  def approve_salary
    @salary_months ||= MonthlyPayslip.where(salary_date: params[:date])
    @salary = @salary_months.first
    @date = params[:date]
  end

  # Actual salary approve process is done using this action.
  # Generating the flash message for approve payslip.
  def approve
    @salary_months ||= MonthlyPayslip.where(salary_date: params[:date])
    @salary_months.each(&:approve_salary)
    flash[:notice] = t('payslip_approve')
    redirect_to approve_monthly_payslip_finance_index_path
  end

  # Retrieve the all employee department for drop down list.
  # Retrieve monthly payslip record of particular employee department
  # for drop down list.
  def view_monthly_payslip
    @departments ||= EmployeeDepartment.all
    @salary_months ||= MonthlyPayslip.select(:salary_date).distinct
  end

  # Create the new payslip array for inserting salary.
  # Fetch the department and date from user input.
  # Insert the particular employee salary in payslips array.
  def view_payslip
    @payslips = []
    @department = EmployeeDepartment.shod(params[:payslip][:department])
    @date = params[:payslip][:date]
    @employees ||= @department.employees
    return if @employees.nil?
    @employees.each do |e|
      salary = e.salary(@date)
      @payslips << salary unless salary.nil?
    end
  end

  # This action generate the pdf of employees payslip list.
  # general setting object retrieve the heading information for pdf
  # e.g. college name,phone number and address.
  def employee_monthly_payslip
    @general_setting = GeneralSetting.first
    @payslips = params[:payslips]
    render 'employee_monthly_payslip', layout: false
  end

  # Fetch the employee id and date from previous action.
  # Generate object for the payslip structure.
  # Generate the object for employee salary and individual salary.
  def view_employee_payslip
    @employee = Employee.shod(params[:id])
    @date = params[:date]
    @structures ||= @employee.employee_salery_structures
    @salary = @employee.salary(@date)
    @individual_salary = @employee.personal_salary(@date)
  end

  # This action generate the information for display pdf.
  # Fetch the employee id and date from previous action.
  # Generate object for the payslip structure.
  # Generate the object for employee salary and individual salary.
  def employee_payslip
    @general_setting = GeneralSetting.first
    @employee = Employee.shod(params[:id])
    @date = params[:date]
    @structures ||= @employee.employee_salery_structures
    @salary = @employee.salary(@date)
    @individual_salary = @employee.personal_salary(@date)
    render 'employee_payslip', layout: false
  end

  # Create the drop down list for selecting batch to display discounts.
  def fee_discounts
    @batches ||= Batch.includes(:course).all
  end

  # create the drop down list for selecting batch to display discounts.
  def fee_collection_view
    @batches ||= Batch.includes(:course).all
  end

  private

  def transaction_category_params
    params.require(:finance_transaction_category).permit!
  end

  def donation_params
    params.require(:finance_donation).permit!
  end

  def asset_params
    params.require(:asset).permit!
  end

  def liability_params
    params.require(:liability).permit!
  end

  def auto_transaction_params
    params.require(:finance_transaction_trigger).permit!
  end

  def transaction_params
    params.require(:finance_transaction).permit!
  end

  def fee_category_params
    params.require(:finance_fee_category).permit!
  end

  def fee_particular_params
    params.require(:finance_fee_particular).permit!
  end

  def fee_discount_params
    params.require(:fee_discount).permit!
  end

  def collection_params
    params.require(:finance_fee_collection).permit!
  end
end
